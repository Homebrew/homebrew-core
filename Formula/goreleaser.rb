class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.80.2.tar.gz"
  sha256 "901681ea70da1d0175d494649e0d73bf1f11c3dfcc74cd6583be858b1c2fe60a"

  bottle do
    cellar :any_skip_relocation
    sha256 "235eab87dc25ba1d8d7d8c8c5d73898453ac082352fda3ac1a215a483a8ddbed" => :high_sierra
    sha256 "1d7453a205dd128d9a5b12c3cd1052de6338c4dd5a0c7a936435916baf283735" => :sierra
    sha256 "02bb92d80879c10220beb0f4af5889a79da974b65c54b1b1077cad63ee95a115" => :el_capitan
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
