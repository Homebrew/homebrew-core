class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/2.0.0-rc4.tar.gz"
  sha256 "3406f3bfab63f81c1533029a5bf73949ff60f22f6e155c5a08005b8b8afe6d49"

  bottle do
    rebuild 1
    sha256 "2024d1074958c1de78287aa67d580a73727409a1dfe4f8cdd48d980ef456fd92" => :catalina
    sha256 "fbe93dacf9d752070395f904bbbad1fdfcf9c88fc11fa7bc232cf1d47e63ae3f" => :mojave
    sha256 "d5a590f4fd4af84251a575a34fa636a8e09c40e9b6795dc17243a32ecd0d3c67" => :high_sierra
    sha256 "9c9b013c4a2b9b2c7eb7542d1b0094b531b8ebed7b88542ff95b775cab0be52c" => :sierra
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git"
    depends_on :xcode => :build
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on :x11

  def install
    system "cmake", ".", *std_cmake_args, "-DWITH_X11=ON", "-DBUILD_SHARED_LIBS=ON"
    system "make", "install"
  end

  test do
    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    if !success && details.exitstatus != 128
      raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp"
    end
  end
end
