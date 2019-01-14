class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.97.0.tar.gz"
  sha256 "4266af065b40fb47fd5be6bc6400d31a666ebee9f29220aceccf91a7c4b503fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "f268e1ac3343b9f5bae4ae363e7d43955fd4c2d10e7feb0e3658e78b448cf874" => :mojave
    sha256 "6e9d013198d1d490fd9e71ebd86ec2cb1808bead8ceb241e08b97001909e4864" => :high_sierra
    sha256 "8b306583b6e348d619af090b97aa1580587bb185f285ba0d4160fbce650ac00f" => :sierra
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
