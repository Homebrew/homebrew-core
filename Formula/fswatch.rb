class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.16.0/fswatch-1.16.0.tar.gz"
  sha256 "95ece85eb01af71e99afef0173755fcedb737b639163f8efc7fed674f6f5372f"
  license all_of: ["GPL-3.0-or-later", "Apache-2.0"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "9286194b4e2df96b68c14a6eb30175b3d6846a457806f898822b611b395c97cd"
    sha256 cellar: :any, arm64_big_sur:  "a9857b4d1cc1320e967edcc5ba5c61bd9215fac591204bc005bc89223f107228"
    sha256 cellar: :any, monterey:       "173627c62aeb6a956a07097a34604e00504e3224c7709858be4c82a2827c343a"
    sha256 cellar: :any, big_sur:        "f930656cf465723b282216767a932555efdfd6b75d0404cd904c52005fad53ac"
    sha256 cellar: :any, catalina:       "a5df0020481ef351591515771abd877adc2968061ce41f4b6429f13d6ab06d30"
    sha256 cellar: :any, mojave:         "4423be79c01f66ffea513d6dcf8758bb9c1a005f77823620c6d93ec6f0bb3da2"
    sha256               x86_64_linux:   "d7940f62b241d4880410bf42184fb1198e60e8cebd8fd4be51ec9801f04a08f0"
  end

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
