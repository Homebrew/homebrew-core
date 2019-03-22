class GoStatik < Formula
  desc "Embed files into a Go executable"
  homepage "https://github.com/rakyll/statik"
  url "https://github.com/rakyll/statik/archive/v0.1.6.tar.gz"
  sha256 "f157a1ada813eb643ddd9a60a0efe3158f1da25b1d11bc1ef6c7fa219d4b23bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfe0bccb598c23616c00d2dc2352f7d62c59e4357b4d29cfbbbfc43c4c461286" => :mojave
    sha256 "4bf8abfe7697cafb71556839067a24ed521c518fd1ad34691316062af0170e6f" => :high_sierra
    sha256 "cbedbf6f6c385c729caba992ac3015a6b09e10643d78aaa7ad133d589740693c" => :sierra
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
    system bin/"statik", "-src", "/Library/Fonts/STIXGeneral.otf"
    assert_predicate testpath/"statik/statik.go", :exist?
    refute_predicate (testpath/"statik/statik.go").size, :zero?
  end
end
