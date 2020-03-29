class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/2.0.0-rc4.tar.gz"
  sha256 "3406f3bfab63f81c1533029a5bf73949ff60f22f6e155c5a08005b8b8afe6d49"

  bottle do
    sha256 "70925b1a37136343df3c26e9448a292df3bb4fd697e7932810ffd75cea986049" => :catalina
    sha256 "fc6e45063612edd6ef3ab54824f9241eea4c36b3a3037b24fdcdb9b2770943f7" => :mojave
    sha256 "d5ac989528db05487c37363ea78d529a6773fdd2c27bafdb509c943ad377a0b6" => :high_sierra
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
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end
