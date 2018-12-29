class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.95.2.tar.gz"
  sha256 "37c91b036d6c5558eb20eeb4f34137e234b4f88c3328ca49e3da208adbd29cff"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa632fa9eed90892a90d916d133c4d07c860810c69aa9cf54db579b8aaf4ecfa" => :mojave
    sha256 "4173e290f639ef0c18447fa5eb4a1f1acd7a223082100fc6685a17c3b1eee4b8" => :high_sierra
    sha256 "3729ba31d0092c7c40d0019851eabe0d4152026a38b0faf4bd90af8a0895f49d" => :sierra
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
