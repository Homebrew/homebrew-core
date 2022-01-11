class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v3.19.3/protobuf-all-3.19.3.tar.gz"
  sha256 "84cca73ed97abce159c381e682ba0237bc21952359b07d8d45dc7e6399edd923"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b4653ec873eb060fd77e0069b37ea9c44d0416627fd22668fc205b64e25414ff"
    sha256 cellar: :any,                 arm64_big_sur:  "ae8aa1204d795af13429f7023d3d905afa55292c8fd456e2d80b5200be18552f"
    sha256 cellar: :any,                 monterey:       "c4334ce36ed368148332519a89d666aeff6fd5a42a4d2b603aee7fe765093a22"
    sha256 cellar: :any,                 big_sur:        "e0654c9a3569be29e5fb533c26d4ce20368ae987dfad85994d0c0da4f0aab5a3"
    sha256 cellar: :any,                 catalina:       "7723b6895f50087e239a696602b6a06406f5bf2197d51616b8c3c4fb359183f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe0c972ca6f7857045387c22de2af1bf048bcdec331caa32df38b15aadecdc78"
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
