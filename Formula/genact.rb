class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/0.7.0.tar.gz"
  sha256 "9bfb241d8d3e77dae63fa3f5c84ef67e459a03a8fc18ed4661e53765264288ce"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "38ba680b756939cbf698a3bb4e135613663e5d7778f15cf03c8cd2fb19abdad7" => :catalina
    sha256 "da6e18f5cbe7a84c8ad3c4a3d079d7ca0deaded383d98ce72afed4f770a02aed" => :mojave
    sha256 "2c962de62551fce95f18b2e46cc9b1140256daa10fcd5555d5cfc2e3999df340" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match /Available modules:/, shell_output("#{bin}/genact --list-modules")
  end
end
