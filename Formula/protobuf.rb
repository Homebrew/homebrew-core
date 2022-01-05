class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v3.19.2/protobuf-all-3.19.2.tar.gz"
  sha256 "85f9f59e5ab0dd1d8d4d71673717fdacbf4f1c9fb4cdda6ed71249c6548c4544"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2c79308d7f48bec84d982266e15856b16f4341bf09e6fec0389267c298926fc6"
    sha256 cellar: :any,                 arm64_big_sur:  "0abdd64a2df3c15c6987ca7f4d43cb461ed792fe03654660571258d344f6112e"
    sha256 cellar: :any,                 monterey:       "0308e29bece56bf668d3f55a7a954f15a4661850cb42bac49b1253f5ae1d38fc"
    sha256 cellar: :any,                 big_sur:        "b6bb6b08578552a249e1ae467d0d0f41cb9bd2672ff2a987ea58412cfd118752"
    sha256 cellar: :any,                 catalina:       "20c06f641f8f65f1b05922d3e073f6f2e9415016b4193c42e6b2274c6add9714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c885d9f84a3077b1828ce9e1bbbfe5e51ad1a81ea07dfec82a1a9b83b72db7b"
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
