class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.93.1.tar.gz"
  sha256 "cdb339ced74dc25513e6533e5ec385f41d7b542c57a86ce9d2cc7e1b5c51e8f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ef2676e4927be7630f5ab3f80fd1bb09ab4e027464720df02e95094f55d04b5" => :mojave
    sha256 "0b2e02f86ea5cc65d620ae108ce4d52e0827a4f415c8f5ddb8e27968c23ce653" => :high_sierra
    sha256 "eaf0e1dc528130f2184b261ff2c604ec7ed2cf01eefc66e677a58dde8a9cd4fe" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/goreleaser/goreleaser").install buildpath.children
    cd "src/github.com/goreleaser/goreleaser" do
      system "go", "build", "-ldflags", "-X main.version=#{version}",
                   "-o", bin/"goreleaser"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
