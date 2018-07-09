class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.79.2.tar.gz"
  sha256 "d8d2cfab66d51c3c1135c4c9c0939052b3c7ac0cb737b3a07870347578b6b6d4"

  bottle do
    cellar :any_skip_relocation
    sha256 "48921a65cf7f90230d3bfaf98250ac9545a7ba1bde887f1a4b682b1a7f992e11" => :high_sierra
    sha256 "24b69bacfe655d3eb531636ea55767395703beda7e93e222e6d58d68f4f52281" => :sierra
    sha256 "8359a6b1f80c90e469a78b9cc58b4643ad6151c7ea0f3741b6005a22843dac3a" => :el_capitan
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
