class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v21.4/protobuf-all-21.4.tar.gz"
  sha256 "6c5e1b0788afba4569aeebb2cfe205cb154aa01deacaba0cd26442f3b761a836"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "85457c7bc72c6969617973e11254df3a0333b9d0738948ffb2c3fb03727b477f"
    sha256 cellar: :any,                 arm64_big_sur:  "9fa073077f61aa63d4892121e94f254cdc8531095514d5d358a702044468abc7"
    sha256 cellar: :any,                 monterey:       "62e6914629cc1f2616cd8b9d91df4683986a19713349ed4c302e201ebcdb4b2d"
    sha256 cellar: :any,                 big_sur:        "48b2d6a2fc3c9c2190e82966be6d282779f9313fd47db8227aca2a9b7af558ad"
    sha256 cellar: :any,                 catalina:       "4bc7d85fcbb65b1996a82cdb6f24a49f88ebd52b80a03f5391ec0bc036263190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e2f6d4d5572bc90e15b3825af94bccff75055196adbf778de2c3f72e5d5e7e3"
  end

  head do
    url "https://github.com/protocolbuffers/protobuf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "python@3.10" => [:build, :test]
  # The Python3.9 bindings can be removed when Python3.9 is made keg-only.
  depends_on "python@3.9" => [:build, :test]

  uses_from_macos "zlib"

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # https://github.com/protocolbuffers/protobuf/blob/5c24564811c08772d090305be36fae82d8f12bbe/configure.ac#L61
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.cxx11

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-zlib"
    system "make"
    system "make", "check"
    system "make", "install"

    # Install editor support and examples
    pkgshare.install "editors/proto.vim", "examples"
    elisp.install "editors/protobuf-mode.el"

    ENV.append_to_cflags "-I#{include}"
    ENV.append_to_cflags "-L#{lib}"

    cd "python" do
      ["3.9", "3.10"].each do |xy|
        site_packages = prefix/Language::Python.site_packages("python#{xy}")
        system "python#{xy}", *Language::Python.setup_install_args(prefix),
                              "--install-lib=#{site_packages}",
                              "--cpp_implementation"
      end
    end
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system bin/"protoc", "test.proto", "--cpp_out=."
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import google.protobuf"
    system Formula["python@3.10"].opt_bin/"python3", "-c", "import google.protobuf"
  end
end
