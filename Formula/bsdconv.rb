class Bsdconv < Formula
  desc "Charset/encoding converter library"
  homepage "https://github.com/buganini/bsdconv"
  url "https://github.com/buganini/bsdconv/archive/11.5.tar.gz"
  sha256 "20137c6937a5785467296e12b18b1b9dff55f021bae3f3eb3eb4fa5826689692"
  head "https://github.com/buganini/bsdconv.git"

  bottle do
    sha256 "cf84c4c19beae5f141575a04a1bdcd7e23a1d4003b779add06cde88676a40142" => :sierra
    sha256 "631f10fd9413f137ba6978cc977fdaee18f0fd349990f9d1aef6d70b3761d885" => :el_capitan
    sha256 "12ddfed17d5d21c304508b6d1534097b2075c5f934012c0428e037f288881d79" => :yosemite
    sha256 "29b9fbe96e4c69dd7b24aab2d810fda568ff82500a2535b7ea484a24c5a84c22" => :mavericks
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = pipe_output("#{bin}/bsdconv BIG5:UTF-8", "\263\134\273\134")
    output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_equal "許蓋", output
  end
end
