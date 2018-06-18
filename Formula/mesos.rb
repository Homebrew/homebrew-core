class Mesos < Formula
  desc "Apache cluster manager"
  homepage "https://mesos.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=mesos/1.4.1/mesos-1.4.1.tar.gz"
  mirror "https://archive.apache.org/dist/mesos/1.4.1/mesos-1.4.1.tar.gz"
  sha256 "5973795a739c9fa8f1d56b7d0ab1e71e015d5915ffdefb46484ac6546306f4b0"

  bottle do
    rebuild 2
    sha256 "002254bfe8c326d8534206e04359139513b4c6338d399a19b49e712745257fe0" => :high_sierra
    sha256 "f80fc3e7e9c4846cd6a28b5385a9bac9ca256fda16ec1a14be24fd2db48dccdc" => :sierra
    sha256 "f21927e965a55ed3ed09bf2507d0785492a439e7faca2aa21d39be9cf2375f78" => :el_capitan
  end

  depends_on :java => "1.8"
  depends_on :macos => :mountain_lion
  depends_on "apr-util" => :build
  depends_on "maven" => :build
  depends_on "python@2"
  depends_on "subversion"

  conflicts_with "nanopb-generator",
    :because => "they depend on an incompatible version of protobuf"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/e0/2f/690a5f047e2cfef40c9c5eec0877b496dc1f5a0625ca6b0ac1cd11f12f6a/protobuf-3.2.0.tar.gz"
    sha256 "a48475035c42d13284fd7bf3a2ffa193f8c472ad1e8539c8444ea7e2d25823a1"
  end

  # build dependencies for protobuf
  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f7/c7/08e54702c74baf9d8f92d0bc331ecabf6d66a56f6d36370f0a672fc6a535/pytz-2016.6.1.tar.bz2"
    sha256 "b5aff44126cf828537581e534cc94299b223b945a2bb3b5434d37bf8c7f3a10c"
  end

  resource "python-gflags" do
    url "https://files.pythonhosted.org/packages/ea/30/b8469c0d1837ce58fe3706e1f7169cbf6ca1fb87d1f84cece5182b67cb0b/python-gflags-3.1.1.tar.gz"
    sha256 "aaff6449ca74320c709052e4664a52337832b2338f4a4267088564f3e98f6c63"
  end

  resource "google-apputils" do
    url "https://files.pythonhosted.org/packages/69/66/a511c428fef8591c5adfa432a257a333e0d14184b6c5d03f1450827f7fe7/google-apputils-0.4.2.tar.gz"
    sha256 "47959d0651c32102c10ad919b8a0ffe0ae85f44b8457ddcf2bdc0358fb03dc29"
  end

  if DevelopmentTools.clang_build_version >= 802 # does not affect < Xcode 8.3
    # _scheduler.so segfault when Mesos is built with Xcode 8.3.2
    # Reported 29 May 2017 https://issues.apache.org/jira/browse/MESOS-7583
    # The issue does not occur with Xcode 9 beta 3.
    fails_with :clang do
      build 802
      cause "Segmentation fault in _scheduler.so"
    end
  end

  # error: 'Megabytes(32).Megabytes::<anonymous>' is not a constant expression
  # because it refers to an incompletely initialized variable
  fails_with :gcc => "7"

  needs :cxx11

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

    # work around to avoid `_clock_gettime` symbol not found error.
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      ENV["ac_have_clock_syscall"] = "no"
    end

    # work around distutils abusing CC instead of using CXX
    # https://issues.apache.org/jira/browse/MESOS-799
    # https://github.com/Homebrew/homebrew/pull/37087
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

    # skip build javadoc because Homebrew's setting user.home in _JAVA_OPTIONS
    # would trigger maven-javadoc-plugin bug.
    # https://issues.apache.org/jira/browse/MESOS-3482
    maven_javadoc_patch = <<~EOS
      <properties>
        <maven.javadoc.skip>true</maven.javadoc.skip>
      </properties>
      \\0
    EOS
    inreplace "src/java/mesos.pom.in",
              "<url>http://mesos.apache.org</url>",
              maven_javadoc_patch

    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --with-svn=#{Formula["subversion"].opt_prefix}
    ]

    unless MacOS::CLT.installed?
      args << "--with-apr=#{Formula["apr-util"].opt_libexec}"
    end

    ENV.cxx11

    system "./configure", "--disable-python", *args
    system "make"
    system "make", "install"

    # The native Python modules `executor` and `scheduler` (see below) fail to
    # link to Subversion libraries if Homebrew isn't installed in `/usr/local`.
    ENV.append_to_cflags "-L#{Formula["subversion"].opt_lib}"

    system "./configure", "--enable-python", *args
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
        if r == "protobuf"
          ln_s buildpath/"protobuf/lib/python2.7/site-packages/google/apputils", "google/apputils"
        end
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
