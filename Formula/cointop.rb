class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.0.6.tar.gz"
  sha256 "6188f21e7fcdfe686324a30a5ccc89a684e2a9acd81f2b042309ec0b28c26272"

  bottle do
    cellar :any_skip_relocation
    sha256 "92f04b4718cddb3a07984ff8636f57032a1bf03790f024a5c30842e820618c37" => :mojave
    sha256 "d325a2cabff5f820bfa29b1b0bf5f8fe95e10aa0910a41a26b4696e00525349d" => :high_sierra
    sha256 "4d3688ea6e5da782ed7fb3f0fdc37f6dea31a6d213bdc826cbba9e0cc6762199" => :sierra
    sha256 "bc0d504ddde42b525af627d5e4b7f9041e8d49179dd822ccedd46f673822fc65" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/miguelmota/cointop").install buildpath.children
    cd "src/github.com/miguelmota/cointop" do
      system "go", "build", "-o", bin/"cointop"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"cointop", "-test"
  end
end
