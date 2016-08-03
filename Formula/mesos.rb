class Mesos < Formula
  desc "Apache cluster manager"
  homepage "https://mesos.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=mesos/1.0.0/mesos-1.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/mesos/1.0.0/mesos-1.0.0.tar.gz"
  sha256 "dabca5b60604fd672aaa34e4178bb42c6513eab59a07a98ece1e057eb34c28b2"

  bottle do
    sha256 "573959e78d890804de03934e94d0099fb8abc155866e8b6d7b4d1bb87ca592aa" => :el_capitan
    sha256 "37eb6c6c704469a5644ee090faef496b064313f497841fbe6c84124941a43a25" => :yosemite
    sha256 "971e2202fd625ed91d1a2a5fc40bb1202868e469f8f2424c00531db10cc8b158" => :mavericks
  end

  depends_on :java => "1.7+"
  depends_on :macos => :mountain_lion
  depends_on :apr => :build
  depends_on "maven" => :build
  depends_on "subversion"

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c4/bb/28324652bedb4ea9ca77253b84567d1347b54df6231b51822eaaa296e6e0/boto-2.42.0.tar.gz"
    sha256 "dcf140d4ce535bb8f5266d1750c16def4d50f6c46eff27fab38b55d0d74d5ac7"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/14/3e/56da1ecfa58f6da0053a523444dff9dfb8a18928c186ad529a24b0e82dec/protobuf-3.0.0.tar.gz"
    sha256 "ecc40bc30f1183b418fe0ec0c90bc3b53fa1707c4205ee278c6b90479e5b6ff5"
  end

  # build dependencies for protobuf
  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f7/c7/08e54702c74baf9d8f92d0bc331ecabf6d66a56f6d36370f0a672fc6a535/pytz-2016.6.1.tar.bz2"
    sha256 "b5aff44126cf828537581e534cc94299b223b945a2bb3b5434d37bf8c7f3a10c"
  end

  resource "python-gflags" do
    url "https://files.pythonhosted.org/packages/1f/01/3ca6527f51b7ff26abb635d4e7e2fa8413c7cf191564cc2c1e535f50dec7/python-gflags-3.0.5.tar.gz"
    sha256 "c7afbabda959f9da2a6100484f84dd12fb83b015d277468513413329bba20878"
  end

  resource "google-apputils" do
    url "https://files.pythonhosted.org/packages/69/66/a511c428fef8591c5adfa432a257a333e0d14184b6c5d03f1450827f7fe7/google-apputils-0.4.2.tar.gz"
    sha256 "47959d0651c32102c10ad919b8a0ffe0ae85f44b8457ddcf2bdc0358fb03dc29"
  end

  needs :cxx11

  def install
    ENV.java_cache

    boto_path = libexec/"boto/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", boto_path
    resource("boto").stage do
      system "python", *Language::Python.setup_install_args(libexec/"boto")
    end
    (lib/"python2.7/site-packages").mkpath
    (lib/"python2.7/site-packages/homebrew-mesos-boto.pth").write "#{boto_path}\n"

    # work around distutils abusing CC instead of using CXX
    # https://issues.apache.org/jira/browse/MESOS-799
    # https://github.com/Homebrew/homebrew/pull/37087
    native_patch = <<-EOS.undent
      import os
      os.environ["CC"] = os.environ["CXX"]
      os.environ["LDFLAGS"] = "@LIBS@"
      \\0
    EOS

    inreplace %w[src/python/executor/setup.py.in
                 src/python/scheduler/setup.py.in],
      "import ext_modules", native_patch

    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --with-svn=#{Formula["subversion"].opt_prefix}
    ]

    unless MacOS::CLT.installed?
      args << "--with-apr=#{Formula["apr"].opt_libexec}"
    end

    ENV.cxx11

    system "./configure", "--disable-python", *args
    system "make"
    system "make", "install"

    system "./configure", "--enable-python", *args
    ["native", "interface", "cli", ""].each do |p|
      cd "src/python/#{p}" do
        system "python", *Language::Python.setup_install_args(prefix)
      end
    end

    # stage protobuf build dependencies
    ENV.prepend_create_path "PYTHONPATH", buildpath/"protobuf/lib/python2.7/site-packages"
    %w[six python-dateutil pytz python-gflags google-apputils].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(buildpath/"protobuf")
      end
    end

    protobuf_path = libexec/"protobuf/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", protobuf_path
    resource("protobuf").stage do
      ln_s buildpath/"protobuf/lib/python2.7/site-packages/google/apputils", "google/apputils"
      system "python", *Language::Python.setup_install_args(libexec/"protobuf")
    end
    pth_contents = "import site; site.addsitedir('#{protobuf_path}')\n"
    (lib/"python2.7/site-packages/homebrew-mesos-protobuf.pth").write pth_contents
  end

  test do
    require "timeout"

    master = fork do
      exec "#{sbin}/mesos-master", "--ip=127.0.0.1",
                                   "--registry=in_memory"
    end
    slave = fork do
      exec "#{sbin}/mesos-slave", "--master=127.0.0.1:5050",
                                  "--work_dir=#{testpath}"
    end
    Timeout.timeout(15) do
      system "#{bin}/mesos", "execute",
                             "--master=127.0.0.1:5050",
                             "--name=execute-touch",
                             "--command=touch\s#{testpath}/executed"
    end
    Process.kill("TERM", master)
    Process.kill("TERM", slave)
    assert File.exist?("#{testpath}/executed")
    system "python", "-c", "import mesos.native"
  end
end
