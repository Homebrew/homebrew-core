class Cbmbasic < Formula
  desc "Commodore BASIC V2 as a scripting language"
  homepage "https://github.com/mist64/cbmbasic"
  url "https://downloads.sourceforge.net/project/cbmbasic/cbmbasic/1.0/cbmbasic-1.0.tgz"
  sha256 "2735dedf3f9ad93fa947ad0fb7f54acd8e84ea61794d786776029c66faf64b04"
  head "https://github.com/mist64/cbmbasic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4e101b38bb21ff46ce301f2c9a0f59f567df9a3265c4906969f1e4426160d9c" => :catalina
    sha256 "c922c6bd9691307444d7c28ebe9d09299aa43efc7987e30f23bad572f990c81d" => :mojave
    sha256 "99490e603e86319b7c4307657bf58511dacb801dddb30ed7c4269feaa19eb6bc" => :high_sierra
    sha256 "018c1d1fa3050bdbd88c092f19c1ca787098ea1183e1227671507af3fca07b52" => :sierra
    sha256 "92762d9b7f5f21190b98d23e7fedf787cccc14e1c82699b60036948beaf1e7d1" => :el_capitan
    sha256 "d7285a8376e20ac008e51814a97f155f8ac80ce94a809c953ee63932a1d2c1d7" => :yosemite
    sha256 "ffe1126f8e12f15471abadf280fa83b8e77770170749805a28fdaa1a1adf51b0" => :mavericks
  end

  def install
    system "make", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}"
    bin.install "cbmbasic"
  end

  test do
    assert_match(/READY.\r\n 1/, pipe_output("#{bin}/cbmbasic", "PRINT 1\n", 0))
  end
end
