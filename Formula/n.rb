class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v6.2.0.tar.gz"
  sha256 "b200b684fd5a7cb352b74108ec53a1d57497b1a97c73479d2ebf8b3474766aea"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e256d9951dd0eecea20f8dfcb08d19445250a3c5b2619b904d3163de7f42ba27" => :catalina
    sha256 "e256d9951dd0eecea20f8dfcb08d19445250a3c5b2619b904d3163de7f42ba27" => :mojave
    sha256 "e256d9951dd0eecea20f8dfcb08d19445250a3c5b2619b904d3163de7f42ba27" => :high_sierra
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
