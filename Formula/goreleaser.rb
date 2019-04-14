class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.104.1.tar.gz"
  sha256 "7fe23cb5812726469523986452d29d15873c7dfb5a391e6704a5fc6fb28dd96a"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd30eb40798ed85b67c5cdafe147eaa5f4adebe67a9be4b7ccdcf0997a7becf9" => :mojave
    sha256 "68a4816e3fed7f1a395a25bf46b18c1368286cb61fa9ac3b188d39cc82b72ed6" => :high_sierra
    sha256 "704a6b5765dc7a7272c3c4804ca21d5f9c4fde19f2634cbcab4f64149c3140d8" => :sierra
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
