class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.4.5.tar.gz"
  sha256 "9a6aa00f7402320deb982105f826da50391d9c55960431244825cae24a45714f"

  bottle do
    cellar :any_skip_relocation
    sha256 "af2f199fea12a9ee81477fe612dcd4631a63ace981bfa895e7d9d64a3da15dd9" => :catalina
    sha256 "a67aca86bdbe257cac87cb7c9b946eb27cf802a8a822c791c3929d3385fa875c" => :mojave
    sha256 "a9060fce8236fd27cf7c461c4c3445d93abce87b8568c439e52decc2791d06d3" => :high_sierra
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
