class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.3.2.tar.gz"
  sha256 "f891c6cc6f651d0376fb7cde4cb402feaf2ecd59a78d7bfbf237d03e98e39920"

  bottle do
    cellar :any_skip_relocation
    sha256 "647a7c2bd33f1e9097cdab9dbecca9413951fcc4a395f866c40f6f266913eee0" => :mojave
    sha256 "3a3a6ef482c9ec6bc44fcc48ac4fb91f9e19ae6779091759511d38dc012a357b" => :high_sierra
    sha256 "328df631ce386e54a84be745a93fe29e5b749cd43e53f990488b26288d439b6d" => :sierra
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
