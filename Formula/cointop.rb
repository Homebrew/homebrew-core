class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.3.6.tar.gz"
  sha256 "091ea8d8e9874bb9fd433057778476e0629302e5a7ed152dba52134ddabf798f"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed5ee2a669cd6af1c9a323b29d3a71feb54e9353a94c8a4d4e980e51d8383292" => :mojave
    sha256 "3b4ec69c6ce20266c35701de7ac5c6efa68b8e8baf40961473b1ac5f0796b6d2" => :high_sierra
    sha256 "4d989ec60a7c43f3d2dd84584c4cf488583597764783f9c256d232687f2f98d8" => :sierra
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
