class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v21.9/protobuf-all-21.9.tar.gz"
  sha256 "c00f05e19e89b04ea72e92a3c204eedda91f871cd29b0bbe5188550d783c73c7"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "242bb8ff5d819a8124f97d51afccee4143c6a391cdd1a21b812a7a5fb5402c68"
    sha256 cellar: :any,                 arm64_big_sur:  "a4a4a05e98e9a975b48b53c278d6179ab636c876bd6727b2c4dac37e263fdd56"
    sha256 cellar: :any,                 monterey:       "769ba8aaf02de8e4ea820c025a34a16209d74b4fd57717d832d4ebfe7d7785fb"
    sha256 cellar: :any,                 big_sur:        "cceb18d3560101a9dd5bf7f55ddaac34427eaea66267fdcc8118e0a9d0aea344"
    sha256 cellar: :any,                 catalina:       "2fc06b99f7e22334c68be27261990866c625edf84950a4d8d3ab1ba42ec6dc7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9471c3cb9513f63bc893bdd2930f4e460ae66e8394303adce735c98402944cd2"
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
