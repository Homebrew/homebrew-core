class Cbmbasic < Formula
  desc "Commodore BASIC V2 as a scripting language"
  homepage "https://github.com/mist64/cbmbasic"
  url "https://downloads.sourceforge.net/project/cbmbasic/cbmbasic/1.0/cbmbasic-1.0.tgz"
  sha256 "2735dedf3f9ad93fa947ad0fb7f54acd8e84ea61794d786776029c66faf64b04"
  license "BSD-2-Clause"
  head "https://github.com/mist64/cbmbasic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e090b459f2e44ad8f04e3e70a25b909fe16771f4b2fa325cc06ea233b019803"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b693c2b8fbfe49736bdc0ae4bce13d96295da75a6683e593c021c9335f6c57fd"
    sha256 cellar: :any_skip_relocation, monterey:       "1328d1be681fd3f2be33cbab9b19e59a71e1ed0a5191c89bf7595ebcf0ef3236"
    sha256 cellar: :any_skip_relocation, big_sur:        "29f1eb35e6acf1bf907d2c89c0f5938507718b290cdeef92dfcee473b00f8fe5"
    sha256 cellar: :any_skip_relocation, catalina:       "f4e101b38bb21ff46ce301f2c9a0f59f567df9a3265c4906969f1e4426160d9c"
    sha256 cellar: :any_skip_relocation, mojave:         "c922c6bd9691307444d7c28ebe9d09299aa43efc7987e30f23bad572f990c81d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "99490e603e86319b7c4307657bf58511dacb801dddb30ed7c4269feaa19eb6bc"
    sha256 cellar: :any_skip_relocation, sierra:         "018c1d1fa3050bdbd88c092f19c1ca787098ea1183e1227671507af3fca07b52"
    sha256 cellar: :any_skip_relocation, el_capitan:     "92762d9b7f5f21190b98d23e7fedf787cccc14e1c82699b60036948beaf1e7d1"
    sha256 cellar: :any_skip_relocation, yosemite:       "d7285a8376e20ac008e51814a97f155f8ac80ce94a809c953ee63932a1d2c1d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e08527ac4b01d5d2c747776b5d8be5ae6e402862a87bafe7331c3c3b49d6170"
  end

  def install
    system "make", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}"
    bin.install "cbmbasic"
  end

  test do
    assert_match(/READY.\r\n 1/, pipe_output("#{bin}/cbmbasic", "PRINT 1\n", 0))
  end
end
