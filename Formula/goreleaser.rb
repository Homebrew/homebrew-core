class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.103.1.tar.gz"
  sha256 "e39a548e727e403ecbd0d90bdc8f3133f592e4f65908e75fe1efafa5a4519db6"

  bottle do
    cellar :any_skip_relocation
    sha256 "867419889ec7dc52e0e306efa989866cc11700c5e76471b7a35e6eae7f0e6f53" => :mojave
    sha256 "85aaa818b525585c05f7a7d773d695349153dd6f78945cd6b07ec23a13cdd0ca" => :high_sierra
    sha256 "26e9b1fc5d23a7bc654cb78141ca77f03d1e0d3eac04573e64d1bc5cf2c8739a" => :sierra
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
