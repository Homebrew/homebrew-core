class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.76.0.tar.gz"
  sha256 "ef00153971db628e1a36a4a4677b5ffac5bfc73e2e5401ffe1f2c9c21f67f9a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "d22d1ea2d14cd7deaa49e75363612c33e8fa17808bd89c7e227ca9fdb7c433d2" => :high_sierra
    sha256 "1fa2a39cf7e3fd9c77a6b46efc2e60801d9ed50d9d25bfae86c94e986ba1a244" => :sierra
    sha256 "bb9241072196625884a6722312350e8d12caa04f630957a23d991739c1e3af4e" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/goreleaser/goreleaser").install buildpath.children
    cd "src/github.com/goreleaser/goreleaser" do
      system "dep", "ensure"
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
