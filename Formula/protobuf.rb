class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v3.19.1/protobuf-all-3.19.1.tar.gz"
  sha256 "80631d5a18d51daa3a1336e340001ad4937e926762f21144c62d26fe2a8d71fe"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "633a92077a0e73eefc11011d4a4a2ed5239cdca4ad9ad121d4e6ac3d8db0db0b"
    sha256 cellar: :any,                 arm64_big_sur:  "953c8ae501f9eeabda1bece1967b88c89dbc0b42d7275f1c16e2560ab75a198d"
    sha256 cellar: :any,                 monterey:       "62aa16f54a1bd191176e7ac12a77ecb664652dc68a426e40e91db8d68b8e158e"
    sha256 cellar: :any,                 big_sur:        "5113d9a71911466bcf7da5d833729c39e43459dd7c4ddccbd96c0f97b957e36f"
    sha256 cellar: :any,                 catalina:       "4a1e16ab36f8cef5e952b9ccae77cfaac942129ffc0935c95665fd834a5e428a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da773f604fe7f3db1e9ead0986fb3fad67bcea2b9df1b0442b07a26eec472d77"
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
  depends_on "six"

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
        system "python#{xy}", *Language::Python.setup_install_args(prefix), "--cpp_implementation"
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
