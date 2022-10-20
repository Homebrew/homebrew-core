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
    sha256 cellar: :any,                 arm64_monterey: "5f507ada52497a6dc2d3044b07faee312348277d4a69467e8eac371d4d4111bb"
    sha256 cellar: :any,                 arm64_big_sur:  "894f6f1f404b3e049751e81c3a2a31bea621e664b3bf317c913946c814f5c4c0"
    sha256 cellar: :any,                 monterey:       "bbf1936a2317f331ab2ab2bd6c981db6de8828feae20b698b186d9504d155507"
    sha256 cellar: :any,                 big_sur:        "3cc298cbd78936785e33ae475b3adc886c48790e77120d58f42a26b9b1b2091c"
    sha256 cellar: :any,                 catalina:       "ffea5a8b744cd725a488457c255ef7cf1c4f01e1cfed58708161021b0a083a66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "427c12abde99ab19c1a284df9d90eb57ea03e89dc5696f36c38ac03e83f6b62b"
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
