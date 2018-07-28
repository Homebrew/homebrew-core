class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.82.1.tar.gz"
  sha256 "026d6d65e09333c515692013db4c917d7897ea42693a489e0a87c31a8197277b"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7cd3feb7e6772f03acd698d85069f2aa48063d35f256145a5160552969307b0" => :high_sierra
    sha256 "69bb8f0e71f2e8f525130bccf1e56a817ace211be2a8ea1f87fdb98221688163" => :sierra
    sha256 "9a9433b578651267b9e6ca37af5b7aafa97e1c47fb294c5b515afdd9c7f79181" => :el_capitan
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
