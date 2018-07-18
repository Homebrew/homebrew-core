class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.80.2.tar.gz"
  sha256 "901681ea70da1d0175d494649e0d73bf1f11c3dfcc74cd6583be858b1c2fe60a"

  bottle do
    cellar :any_skip_relocation
    sha256 "d004d64f7cf820b6f4bf604934c3c058cb8ea7ec8bf1f2cfc4244d2f6abfea79" => :high_sierra
    sha256 "6f58e9c0d799ec000b7e7300e3511e7660362314ad2580707469206bec3f6e3a" => :sierra
    sha256 "ee8f697b2ff36ac2614791d8a722ec8c56b0c050a5ae3553822bcb30bb3134c9" => :el_capitan
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
