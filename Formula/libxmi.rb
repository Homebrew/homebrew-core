class Libxmi < Formula
  desc "C/C++ function library for rasterizing 2D vector graphics"
  homepage "https://www.gnu.org/software/libxmi/"
  url "https://ftp.gnu.org/gnu/libxmi/libxmi-1.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/libxmi/libxmi-1.2.tar.gz"
  sha256 "9d56af6d6c41468ca658eb6c4ba33ff7967a388b606dc503cd68d024e08ca40d"
  license "GPL-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d4415d53e7ab98998a088de1148339142edd47d8abf8058d9014b077907ef07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f62b288c26ca17a79f7c066f82a0a26b84e768960095eefdcf6c0c3b420d4a1"
    sha256 cellar: :any_skip_relocation, monterey:       "fafba3428a0f8d222ed035043883dc2230be492abc71fd8eb140b2b3e1884922"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5e9c2fce42f171773589cb0b1bfbf88cadf5036d86a6f502d5f415b8ad20f62"
    sha256 cellar: :any_skip_relocation, catalina:       "eabebd41538c5b53f5ac3d25e71636b8d3561150f4622769107c58a10283e525"
    sha256 cellar: :any_skip_relocation, mojave:         "ee621ddddf3165736ebe0eb44ee0ea4eac0080ca328404311de57acc99402694"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b4fae54573368c35c388850617545ab6f3fdd59bdcc8dde766e863b605278a40"
    sha256 cellar: :any_skip_relocation, sierra:         "d14120dd7ec249b6375da84c5dbf49631d8e8aaf7c0ee9e6c8e9c42f341cc91f"
    sha256 cellar: :any_skip_relocation, el_capitan:     "d7be88ce4d945b11adc82fe6bac6aca8a837e0206cd781e4cab82c8c1b684e20"
    sha256 cellar: :any_skip_relocation, yosemite:       "b8a406a6559eb59890d519e41c824f75f1b37027e6dda108f3648d85480ba5f8"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
    system "make", "install"
  end
end
