class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client."
  homepage "http://i2pd.website/"
  head "https://github.com/PurpleI2P/i2pd.git"

  stable do
    url "https://github.com/PurpleI2P/i2pd/archive/2.8.0.tar.gz"
    sha256 "3f3f538b3c5b3095021311b434456c42d6f3b5e43dc7972c263b10ef179ba063"
  end

  depends_on "libressl"
  depends_on "boost"

  def install
    system "make", "HOMEBREW=1"

    bin.install "i2pd"
  end

  test do
    system "#{bin}/i2pd", "--help"
  end
end
