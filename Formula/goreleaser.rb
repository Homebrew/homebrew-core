class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.82.1.tar.gz"
  sha256 "026d6d65e09333c515692013db4c917d7897ea42693a489e0a87c31a8197277b"

  bottle do
    cellar :any_skip_relocation
    sha256 "35949994b733be9d3a2c8dde16dd8cedb24f783d87d0da90e3ac0a28f24256fb" => :high_sierra
    sha256 "dac70c484e63b9865c89d05333c348facb46d3aacca54243b7f438c45da80fdf" => :sierra
    sha256 "012b252df530ce31b2358b08cd3dce7c8c11d1423403443584a64985a2289d35" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/goreleaser/goreleaser").install buildpath.children
    cd "src/github.com/goreleaser/goreleaser" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o",
             bin/"goreleaser"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
