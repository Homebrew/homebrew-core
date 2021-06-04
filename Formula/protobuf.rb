class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v3.17.2/protobuf-all-3.17.2.tar.gz"
  sha256 "8f118c1d5f83fbe8c3fc805007b40e689b22b7baf79ab923ca00455d4284b799"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6128bdadb84923d51c3a747b4c1ea1a10e03db5afb4b292500b3b3b95418feaf"
    sha256 cellar: :any, big_sur:       "72c6dfdc47c6bfc53f184795602300daddefdc85a129379d58ef61b1208f3c22"
    sha256 cellar: :any, catalina:      "b8ce14f97cdee69d3d91928e655e1a8250d76b1dc7c67f5f06c0464e6f43b75b"
    sha256 cellar: :any, mojave:        "d9fe451840d739939d36060353295ec3cd83c50224de4bfb00e88bcf29861bbe"
  end

  head do
    url "https://github.com/protocolbuffers/protobuf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "python@3.9" => [:build, :test]
  depends_on "six"

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

    chdir "python" do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix),
                        "--cpp_implementation"
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
  end
end
