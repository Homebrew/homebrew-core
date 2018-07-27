class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.82.0.tar.gz"
  sha256 "f891d43339ade0130e7258617a54ebda34b556b2a81f701fa84c4163e11bbc76"

  bottle do
    cellar :any_skip_relocation
    sha256 "8785196e498b76003a0bbf630d695f76c9beccbe07ae13bc361909f32de44fb9" => :high_sierra
    sha256 "8c982971acfede75dc11f9cf23f064e7f04ce32e65a8162a0ec701cab6670d42" => :sierra
    sha256 "b003af1570ebec5db63984425a30cdaea0c36ab68088c1d81983d7757a03b61e" => :el_capitan
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
