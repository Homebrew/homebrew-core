class Nethogs < Formula
  desc "Net top tool grouping bandwidth per process"
  homepage "https://raboof.github.io/nethogs/"
  url "https://github.com/raboof/nethogs/archive/v0.8.5.tar.gz"
  sha256 "6a9392726feca43228b3f0265379154946ef0544c2ca2cac59ec35a24f469dcc"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc7d9af4eebb27c162e280dd551742ed0346cc807e45980e2ce6de8b1f8b26ff" => :catalina
    sha256 "a43516ede7e2046c39f1984e4afaee53a3705a81d78491827e33a6a3f631bed8" => :mojave
    sha256 "b70632b33aeb7f23c93cbd27cdb36d49382f3619684c32b60c76129a5d64195e" => :high_sierra
    sha256 "25731b08cad9b8f5a420172bab21d6986d49ee7044cbdd3a7717c6b10ee8da8d" => :sierra
    sha256 "f133cdfd28bd88778241a607fda39d17419d8aaf24fd6de49d8a086e112fc7bf" => :el_capitan
    sha256 "aa00775f5f8add09c031b13d3ec2575b082da47aa573e869288b28cad879f431" => :yosemite
    sha256 "3652cadd0558c01c522e586a483b03b95badf98028ab3b7f9a227f8bae275def" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Using -V because other nethogs commands need to be run as root
    system sbin/"nethogs", "-V"
  end
end
