class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.3.3.tar.gz"
  sha256 "5ea4e67f00041d43d66da4c3d427f31ba1875ba2b9083f568ebb6cd68ec4a00c"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4cd8807f0f212705ef5dcba1d60e6dea994d54495df8959c955518d33853e29" => :mojave
    sha256 "59d75039c9aeb0858bd568637ecfc39a214874e9d04b05034aae004e4a976729" => :high_sierra
    sha256 "ce935637d0f2889713420ff986d1f5683219542a40665c5cac26db0bb8b59e4f" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/miguelmota/cointop"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"cointop"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"cointop", "test"
  end
end
