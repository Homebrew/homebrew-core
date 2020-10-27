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
    cellar :any
    rebuild 1
    sha256 "847cacb946b6289a5fbfbfe4e1a38f1ec5b7f1e32d6c12145aaf1044317e4ce0" => :catalina
    sha256 "5efee306aff13a0c0b8f98371e3cbe3eab6b73b0e92bdd59237d7db608a17708" => :mojave
    sha256 "e1b6641d11a5338d395de8f5573464beddb81dc3dce16998e53361b43502844b" => :high_sierra
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
