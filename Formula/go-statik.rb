class GoStatik < Formula
  desc "Embed files into a Go executable"
  homepage "https://github.com/rakyll/statik"
  url "https://github.com/rakyll/statik/archive/v0.1.7.tar.gz"
  sha256 "cd05f409e63674f29cff0e496bd33eee70229985243cce486107085fab747082"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f746f843baa189a6c418fbd0ab441e5fce4cadfaa3b85cb10b694b55a144d3b" => :catalina
    sha256 "4e347596a83f169bdb0b72cd81d69ea275966fead97f7decb67c873380c179b8" => :mojave
    sha256 "4ec52d9626abcbb07f25640c9ecec4e620faa9ee619f6f289f172aa7bc509590" => :high_sierra
    sha256 "e0e8c356eb1ed32cf074d4abfa81fd8fa9d6d8dfb7c7724c696a521f974a3b44" => :sierra
  end

  depends_on "go" => :build

  conflicts_with "statik", :because => "both install `statik` binaries"

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/rakyll/statik").install buildpath.children

    cd "src/github.com/rakyll/statik" do
      system "go", "build", "-o", bin/"statik"
      prefix.install_metafiles
    end
  end

  test do
    font_name = (MacOS.version >= :catalina) ? "Arial Unicode.ttf" : "Arial.ttf"
    system bin/"statik", "-src", "/Library/Fonts/#{font_name}"
    assert_predicate testpath/"statik/statik.go", :exist?
    refute_predicate (testpath/"statik/statik.go").size, :zero?
  end
end
