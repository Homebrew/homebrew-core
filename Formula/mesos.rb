class Mesos < Formula
  desc "Apache cluster manager"
  homepage "https://mesos.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=mesos/1.10.0/mesos-1.10.0.tar.gz"
  mirror "https://archive.apache.org/dist/mesos/1.10.0/mesos-1.10.0.tar.gz"
  sha256 "f4b9e8a1e9f905334adf4d349a2ed33a4cfa43278381cd34fb4fc7e9df9e12a1"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    sha256 "9b16abfb73c36bfd2b8a8f7648968730afb3fb30066b8886ddfb1dc287122f5c" => :catalina
    sha256 "6c9c8120d0e6057f0637290a1845855b06e8830d9695d5d11ccabfcbb494bcb5" => :mojave
    sha256 "b8cad31bd364be2eef13f360f8b9315b4a00caac8308dd4f52f76e02b56dcb5e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "maven" => :build
  depends_on "apr-util"
  depends_on :macos # Due to Python 2
  depends_on "openjdk@8"
  depends_on "subversion"

  conflicts_with "nanopb-generator", because: "they depend on an incompatible version of protobuf"
  conflicts_with "rapidjson", because: "mesos installs a copy of rapidjson headers"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/1b/90/f531329e628ff34aee79b0b9523196eb7b5b6b398f112bb0c03b24ab1973/protobuf-3.6.1.tar.gz"
    sha256 "1489b376b0f364bcc6f89519718c057eb191d7ad6f1b395ffd93d1aa45587811"
  end

  # build dependencies for protobuf
  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/a0/b0/a4e3241d2dee665fea11baec21389aec6886655cd4db7647ddf96c3fad15/python-dateutil-2.7.3.tar.gz"
    sha256 "e27001de32f627c22380a688bcc43ce83504a7bc5da472209b4c70f02829f0b8"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/ca/a9/62f96decb1e309d6300ebe7eee9acfd7bccaeedd693794437005b9067b44/pytz-2018.5.tar.gz"
    sha256 "ffb9ef1de172603304d9d2819af6f5ece76f2e85ec10692a524dd876e72bf277"
  end

  resource "python-gflags" do
    url "https://files.pythonhosted.org/packages/df/ec/e31302d355bcb9d207d9b858adc1ecc4a6d8c855730c8ba4ddbdd3f8eb8d/python-gflags-3.1.2.tar.gz"
    sha256 "40ae131e899ef68e9e14aa53ca063839c34f6a168afe622217b5b875492a1ee2"
  end

  resource "google-apputils" do
    url "https://files.pythonhosted.org/packages/69/66/a511c428fef8591c5adfa432a257a333e0d14184b6c5d03f1450827f7fe7/google-apputils-0.4.2.tar.gz"
    sha256 "47959d0651c32102c10ad919b8a0ffe0ae85f44b8457ddcf2bdc0358fb03dc29"
  end

  def install
    # Disable optimizing as libc++ does not play well with optimized clang
    # builds (see https://llvm.org/bugs/show_bug.cgi?id=28469 and
    # https://issues.apache.org/jira/browse/MESOS-5745).
    #
    # NOTE: We cannot use `--disable-optimize` since we also pass e.g.,
    # CXXFLAGS via environment variables. Since compiler flags are passed via
    # environment variables the Mesos build will silently ignore flags like
    # `--[disable|enable]-optimize`.
    ENV.O0 unless DevelopmentTools.clang_build_version >= 900

    # work around distutils abusing CC instead of using CXX
    # https://issues.apache.org/jira/browse/MESOS-799
    # https://github.com/Homebrew/legacy-homebrew/pull/37087
    native_patch = <<~EOS
      import os
      os.environ["CC"] = os.environ["CXX"]
      os.environ["LDFLAGS"] = "@LIBS@"
      \\0
    EOS
    inreplace "src/python/executor/setup.py.in",
              "import ext_modules",
              native_patch

    inreplace "src/python/scheduler/setup.py.in",
              "import ext_modules",
              native_patch

    ENV.cxx11

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-apr=#{Formula["apr"].opt_libexec}",
                          "--with-svn=#{Formula["subversion"].opt_prefix}",
                          "--disable-python"
    system "make"
    system "make", "install"

    # The native Python modules `executor` and `scheduler` (see below) fail to
    # link to Subversion libraries if Homebrew isn't installed in `/usr/local`.
    ENV.append_to_cflags "-L#{Formula["subversion"].opt_lib}"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-apr=#{Formula["apr"].opt_libexec}",
                          "--with-svn=#{Formula["subversion"].opt_prefix}",
                          "--enable-python"
    ["native", "interface", "executor", "scheduler", "cli", ""].each do |p|
      cd "src/python/#{p}" do
        system "python", *Language::Python.setup_install_args(prefix)
      end
    end

    # stage protobuf build dependencies
    ENV.prepend_create_path "PYTHONPATH", buildpath/"protobuf/lib/python2.7/site-packages"
    %w[python-dateutil pytz python-gflags google-apputils].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(buildpath/"protobuf")
      end
    end

    protobuf_path = libexec/"protobuf/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", protobuf_path
    %w[six protobuf].each do |r|
      resource(r).stage do
        ln_s buildpath/"protobuf/lib/python2.7/site-packages/google/apputils", "google/apputils" if r == "protobuf"
        system "python", *Language::Python.setup_install_args(libexec/"protobuf")
      end
    end
    pth_contents = "import site; site.addsitedir('#{protobuf_path}')\n"
    (lib/"python2.7/site-packages/homebrew-mesos-protobuf.pth").write pth_contents

    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
    sbin.env_script_all_files(libexec/"sbin", Language::Java.java_home_env("1.8"))
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/mesos-agent --version")
    assert_match version.to_s, shell_output("#{sbin}/mesos-master --version")
    assert_match "Usage: mesos", shell_output("#{bin}/mesos 2>&1", 1)
    system "python", "-c", "import mesos.native"
  end
end
