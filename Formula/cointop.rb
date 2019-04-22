class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.1.4.tar.gz"
  sha256 "269ed89b28a01ffa0712968f57369b104e93affe26e346052b0f3ab0cd498306"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c025b09009d37cfffeb62f6571f4f8fa2a41c9f7410093df981b8ae240fa16a" => :mojave
    sha256 "48d40919b248fc9954202b1e84b77e2a8da9ec74dc3913575c5601bf3a384610" => :high_sierra
    sha256 "f02a1de5c7ad86be3d5a6d4e48b4f0baa2c7c53dbc90415fd806dec95f354ff9" => :sierra
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
    system bin/"cointop", "-test"
  end
end
