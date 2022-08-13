class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v21.5/protobuf-all-21.5.tar.gz"
  sha256 "7ba0cb2ecfd9e5d44a6fa9ce05f254b7e5cd70ec89fafba0b07448f3e258310c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "65db16092c200e43b2022ac85e595e01d1f63231075fb45cf1575a9527dacb28"
    sha256 cellar: :any,                 arm64_big_sur:  "27ab263b5f859f05f799d367fe2c27dbc27af9b8a0bb8fa0634d380ea055e09f"
    sha256 cellar: :any,                 monterey:       "0cc9eb3374db9ddaeaa91c814705639731f3966b0399b041bb9022f47a20a079"
    sha256 cellar: :any,                 big_sur:        "09e243ee08872ea442554ef705fbd55e0643da1124d9ea06757053ccaeca9792"
    sha256 cellar: :any,                 catalina:       "cd30f382dddb31b7fd1d36555cbf65d8b1880bdec0394fb68769a2d57c334ef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df6092eefc2554ea52282bed1500254cd1adfc7f98c2c9a50362e38c36c4327b"
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
