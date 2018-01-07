class GoStatik < Formula
  desc "Embed files into a Go executable"
  homepage "https://github.com/rakyll/statik"
  url "https://github.com/rakyll/statik/archive/v0.1.1.tar.gz"
  sha256 "c68ef3120a22bcf5bd5e8391db3507baeefc7047aa6539053229885287d0beb3"

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
