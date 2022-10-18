class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v21.8/protobuf-all-21.8.tar.gz"
  sha256 "83ad4faf95ff9cbece7cb9c56eb3ca9e42c3497b77001840ab616982c6269fb6"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "81f6dfaacdbc7fba8b907897eff030cad8e4ff9fcb49cd63158debd8cdaeeaa8"
    sha256 cellar: :any,                 arm64_big_sur:  "0bbcc9c1ed9065b7a0212cc73ae740ca6df61cb85ed03be60ac19f2e58e39a2d"
    sha256 cellar: :any,                 monterey:       "d5f44d5b95170b5d8d1d2e64c79a4295f94242e7314f7778fffc2a10b869003b"
    sha256 cellar: :any,                 big_sur:        "91806ed47ad28e142559408cd21a766e62169ff245a1bee9e7db171f0723f607"
    sha256 cellar: :any,                 catalina:       "902bb822ba1c8cdbc7e6cb81f97b4a630d7c7dba036da05537ebf5a888511c00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4262c7e1f5141b859e620cea0e6ee671e4c31d826f0414163948973e4750ca54"
  end

  head do
    url "https://github.com/protocolbuffers/protobuf.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "python@3.10" => [:build, :test]
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
        system "python#{xy}", *Language::Python.setup_install_args(prefix, "python#{xy}"), "--cpp_implementation"
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

    system Formula["python@3.9"].opt_bin/"python3.9", "-c", "import google.protobuf"
    system Formula["python@3.10"].opt_bin/"python3.10", "-c", "import google.protobuf"
  end
end
