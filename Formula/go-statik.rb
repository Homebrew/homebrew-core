class GoStatik < Formula
  desc "Embed files into a Go executable"
  homepage "https://github.com/rakyll/statik"
  url "https://github.com/rakyll/statik/archive/v0.1.3.tar.gz"
  sha256 "00ee555333fc49f7782b744c615f85a7552a60a7ca12b18e5c9b7ccb66ca37fc"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1be81d490c76fa8dd3cefc34da67f4bae12af864698184af5be27e5a85ecf67" => :high_sierra
    sha256 "3f7a5afdad6fc23fa15218ca7f886941dff5bf30db923d33914f28b6d1846f36" => :sierra
    sha256 "e2fb6992f472e04e283f15f5fa51d2c472f8c311b3cac93e0a992c0d638dc5f8" => :el_capitan
  end

  depends_on "go" => :build

  conflicts_with "statik", :because => "both install `statik` binaries"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rakyll/statik").install buildpath.children

    cd "src/github.com/rakyll/statik" do
      system "go", "build", "-o", bin/"statik"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"statik", "-src", "/Library/Fonts/STIXGeneral.otf"
    assert_predicate testpath/"statik/statik.go", :exist?
    refute_predicate (testpath/"statik/statik.go").size, :zero?
  end
end
