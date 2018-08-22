class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.83.3.tar.gz"
  sha256 "37614330b19709de4fab649a8e15b78208dca3a119314256fa064cbc4ad8acac"

  bottle do
    cellar :any_skip_relocation
    sha256 "682435c8486ac56ea2ec6b3afff2c0778eb8d2d99201e45f4e7b6ede6a513e19" => :high_sierra
    sha256 "d0a6c2de502022aa76d77e8b20c8b62f6d1f5a47387e3c75318cc7de4a8f7909" => :sierra
    sha256 "4aacc817b3775fc76cfa57358c263cd9fa85a3a304c75678b06e547986e3cfb5" => :el_capitan
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
