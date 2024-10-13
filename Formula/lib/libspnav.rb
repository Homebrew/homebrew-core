class Libspnav < Formula
  desc "Client library for connecting to 3Dconnexion's 3D input devices"
  homepage "https://spacenav.sourceforge.net/"
  url "https://github.com/FreeSpacenav/libspnav/releases/download/v1.1/libspnav-1.1.tar.gz"
  sha256 "04b297f68a10db4fa40edf68d7f823ba7b9d0442f2b665181889abe2cea42759"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d82e7c5ecb4060c9d5301501c62d73cdb70827f02b561fb10c969cdb8b7d3ce6"
    sha256 cellar: :any,                 arm64_sonoma:   "59c106ad2742952f55dcdfe28881537b12cbbd2f4dc3550192b2a87a88cc31c9"
    sha256 cellar: :any,                 arm64_ventura:  "5bffbb2a231c0c4ae6b4cbcfe58d5a6aa1fd2459681462fafae815b965f754c7"
    sha256 cellar: :any,                 arm64_monterey: "805c36825ae869487c0e122ad802cbc9ae65ef9e025579199f1462e0f90ed9bb"
    sha256 cellar: :any,                 arm64_big_sur:  "e4608a7496c3941c0b1867745d3d613d3d50a67208094d0a7d4e56fdbe8e4836"
    sha256 cellar: :any,                 sonoma:         "f4385485e3c85222cb493b246198527e3da9edf84adb03c7caf829f96035698b"
    sha256 cellar: :any,                 ventura:        "7c01d1c7d88b845a23670b14576ce1d8d407e691187af83048ad4d1c8b9c9e3d"
    sha256 cellar: :any,                 monterey:       "be943c5f3129713ec763a4616f39dbd9b42ce1840c97f48dbd569d14334fb87e"
    sha256 cellar: :any,                 big_sur:        "426b551c6ca93b494ddebd517baca82cb911625bf9b6b7d6f97d405be140833c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0288eba7fc2a946a58922400ce7810acf79c7076e151f2d51e91258bc3e19061"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-x11
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <spnav.h>

      int main() {
        bool connected = spnav_open() != -1;
        if (connected) spnav_close();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lspnav", "-lm", "-o", "test"
    system "./test"
  end
end
