class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v21.7/protobuf-all-21.7.tar.gz"
  sha256 "e07046fbac432b05adc1fd1318c6f19ab1b0ec0655f7f4e74627d9713959a135"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "11267e08f84d284a85749be270a2cda5aa6bafd37c55bd6947a9f9c1a972df1c"
    sha256 cellar: :any,                 arm64_big_sur:  "4d6fea844ce0bd0d126bd487741bd2d2079335ac83d0aa2583a7b9b0fb17e7c5"
    sha256 cellar: :any,                 monterey:       "a2896da738f5681b7e97130d1ffa58e5efbbbaf8646f4f7119c89193706730be"
    sha256 cellar: :any,                 big_sur:        "789c1e874f6de8cbd84b0ad94a02ffd34b0faa44276ff3548f618a0d3c8b3223"
    sha256 cellar: :any,                 catalina:       "7d71f7953e307680cbb5c93f3c473e5a61c1ecbb648483a384bcede0a0817c54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d27d3c261ef65f18260d92cc18160195951db9201b5b942b6ae9df905b705ea5"
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
