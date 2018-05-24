class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/0.5.0.tar.gz"
  sha256 "ad308d362c8eded7865651806a1938c9e62b81a68af81c2dd1c967a4c638e78a"

  bottle do
    sha256 "cda0788c8c4b3430489284c98970a45fa4111cbcaada6112ec2171e70bc2de17" => :high_sierra
    sha256 "0eba28cdb57f5bb297796668c65aff4eda911b7b23698306f27b0dcf19706156" => :sierra
    sha256 "be6e7870976653c8d2a91f42fb8380531aa333f729d8d3298b4009efacc6a09d" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    assert_match /Available modules:/, shell_output("#{bin}/genact --list-modules")
  end
end
