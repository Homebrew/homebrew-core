class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v3.17.1/protobuf-all-3.17.1.tar.gz"
  sha256 "7dd46c0fef046c056adc7a1bf7dfd063f19cbcb206133441ca315ab73572d8a8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8e5a79968dc5b41f8cc8e28e5ef4bc683d1dbb45748ab3e02fdffe440ad6c6b3"
    sha256 cellar: :any, big_sur:       "854c7a9b9eb7db2b9bd43a0946b3569c59435797a48e23071daa8490a7c9c58e"
    sha256 cellar: :any, catalina:      "b7fbbd221a4a4b75a4560b08c6f9c1c70b306543c9304b096639d1c3fb919fcb"
    sha256 cellar: :any, mojave:        "3957b43ba872e74ebd6483eb510646a6398766f8b3774f542b713463c3a99f35"
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
