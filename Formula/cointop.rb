class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.4.6.tar.gz"
  sha256 "69391a7c6f3a920c175685b9917086d449f4c1ff72c5b98ab08118489f15c0a9"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c5c3dd8363fa4b9d138cbf5a8689618b69f3cc4854b1216de0bc7299b68f4bd" => :catalina
    sha256 "d04baa2622fcb278c5924a1eb8658ca2360b92864267008fa0e9007739c783c2" => :mojave
    sha256 "672b40275b391c7ea1ea215eda5ac2c09df08a583adc6c2d7f59af41ad174c3e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"cointop"
    prefix.install_metafiles
  end

  test do
    system bin/"cointop", "test"
  end
end
