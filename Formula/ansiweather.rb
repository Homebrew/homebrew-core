class Ansiweather < Formula
  desc "Weather in your terminal, with ANSI colors and Unicode symbols"
  homepage "https://github.com/fcambus/ansiweather"
  url "https://github.com/fcambus/ansiweather/archive/1.17.0.tar.gz"
  sha256 "eabc5ad709e2a459d59402b190511b44542eafce293205a29fb2b73c3e075ee7"
  license "BSD-2-Clause"
  head "https://github.com/fcambus/ansiweather.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ef34ba57b350fcf65cfd5fbcab88c5209c75d225e2af9a8b9c48bffc99d01b37"
  end

  depends_on "jq"

  def install
    bin.install "ansiweather"
  end

  test do
    assert_match "Wind", shell_output("#{bin}/ansiweather")
  end
end
