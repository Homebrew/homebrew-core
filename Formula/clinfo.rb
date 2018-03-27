class Clinfo < Formula
  desc "Print information about OpenCL platforms and devices"
  homepage "https://github.com/Oblomov/clinfo"
  url "https://github.com/Oblomov/clinfo/archive/2.2.18.03.26.tar.gz"
  sha256 "64b02e68ccff3b95437bd0bd70dcb88438c58adec16a7145a5d4e5c26a898ccf"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b6a50921c63d3dc84ed278ccc5244b99c2d59ebdcd3c99e86bcce221f88e00d" => :high_sierra
    sha256 "e3ed5dd873bb1457e8437e4b51bfa06813a52370eea4103c2fe7b6e69c555e6b" => :sierra
    sha256 "c4ad588f53171f0b63d4065622a2d2c67ef58cfddff7cfc61f4dbc133075df61" => :el_capitan
  end

  def install
    system "make", "MANDIR=#{man}", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match /Device Type +CPU/, shell_output(bin/"clinfo")
  end
end
