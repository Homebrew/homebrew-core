class Musepack < Formula
  desc "Audio compression format and tools"
  homepage "https://www.musepack.net/"
  url "https://files.musepack.net/source/musepack_src_r475.tar.gz"
  version "r475"
  sha256 "a4b1742f997f83e1056142d556a8c20845ba764b70365ff9ccf2e3f81c427b2b"

  livecheck do
    url "https://www.musepack.net/index.php?pg=src"
    regex(/href=.*?musepack(?:[._-]src)?[._-](r\d+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "76db5599c7e47ab4317292c040ef16095f658ee3b524d89c0296a574380a4570"
    sha256 cellar: :any, arm64_big_sur:  "ce4329e0fc5d5d1a1e518e7c1f471ef300ff96ddaea0219e70e4408924f75ff6"
    sha256 cellar: :any, monterey:       "9f74dcc9567656a42082125ce4d758c3318a452dbd940b6db39b72c4981768da"
    sha256 cellar: :any, big_sur:        "e9221e9612e1c0134554fbf380639cd995a5970ad34702bea371633f121ffb3e"
    sha256 cellar: :any, catalina:       "847cacb946b6289a5fbfbfe4e1a38f1ec5b7f1e32d6c12145aaf1044317e4ce0"
    sha256 cellar: :any, mojave:         "5efee306aff13a0c0b8f98371e3cbe3eab6b73b0e92bdd59237d7db608a17708"
    sha256 cellar: :any, high_sierra:    "e1b6641d11a5338d395de8f5573464beddb81dc3dce16998e53361b43502844b"
  end

  depends_on "cmake" => :build
  depends_on "libcuefile"
  depends_on "libreplaygain"

  resource "test-mpc" do
    url "https://trac.ffmpeg.org/raw-attachment/ticket/1160/decodererror.mpc"
    sha256 "b16d876b58810cdb7fc06e5f2f8839775efeffb9b753948a5a0f12691436a15c"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    lib.install "libmpcdec/libmpcdec.dylib"
  end

  test do
    resource("test-mpc").stage do
      assert_match(/441001 samples decoded in/,
                   shell_output("#{bin}/mpcdec decodererror.mpc 2>&1"))
    end
  end
end
