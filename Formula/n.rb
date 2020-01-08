class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v6.1.3.tar.gz"
  sha256 "90b7ae4ac9d013ab99d0766450e431b4709a40d37a3ff25a53b85747c2f82276"
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
