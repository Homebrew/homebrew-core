class Libxmi < Formula
  desc "C/C++ function library for rasterizing 2D vector graphics"
  homepage "https://www.gnu.org/software/libxmi/"
  url "https://ftp.gnu.org/gnu/libxmi/libxmi-1.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/libxmi/libxmi-1.2.tar.gz"
  sha256 "9d56af6d6c41468ca658eb6c4ba33ff7967a388b606dc503cd68d024e08ca40d"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "ee621ddddf3165736ebe0eb44ee0ea4eac0080ca328404311de57acc99402694" => :mojave
    sha256 "b4fae54573368c35c388850617545ab6f3fdd59bdcc8dde766e863b605278a40" => :high_sierra
    sha256 "d14120dd7ec249b6375da84c5dbf49631d8e8aaf7c0ee9e6c8e9c42f341cc91f" => :sierra
    sha256 "d7be88ce4d945b11adc82fe6bac6aca8a837e0206cd781e4cab82c8c1b684e20" => :el_capitan
    sha256 "b8a406a6559eb59890d519e41c824f75f1b37027e6dda108f3648d85480ba5f8" => :yosemite
    sha256 "fe1bd51baf04d248d233d92ed8c2343d49b03e09427dd6774a86cabfc21372e9" => :mavericks
    sha256 "1bfaff32eb89a52d7a3b3ef98e2e7070df837d904590c0c54e31df3e61e01172" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
    system "make", "install"
  end
end
