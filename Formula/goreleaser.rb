class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.85.2.tar.gz"
  sha256 "9414bebd31b82fc7ef78115379e31af3de233c9e34de231c5b72879d4b811c3a"

  bottle do
    cellar :any_skip_relocation
    sha256 "86384b571d82c3c738726375b2b783434c51656097d751deb6f866fd3c5686b2" => :mojave
    sha256 "e8b9328fe844930be25432efc4b9b873a66978bfd13d8374e708f44229eb5104" => :high_sierra
    sha256 "7c9ae135bf5d4ce7b7e4bfd1ae906ce35ab63e86dce24a082c3d56c11f7a3434" => :sierra
    sha256 "226baeeae6f6771cf86681a9deded631def0a1de4bb0dd9b1890af90100727a6" => :el_capitan
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
