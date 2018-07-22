class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.81.0.tar.gz"
  sha256 "fd4c6c3fc105c80a8d4fbfe73c68ce257adfb2e5a95e000b6a59ca2a1b0012a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "5083e53e4ee2a962f259f0b0b4dfbba1bf4a8cbac599282e0947df2ef9d8070a" => :high_sierra
    sha256 "f4c802527c10bef23b8041137f5bcca753ff7a1d45cc1e1a5aa8e799f22349ba" => :sierra
    sha256 "44ab601fe2ac4aee994180bd13444d97f5542ad6a582b491e8632ee9ee8d78f0" => :el_capitan
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
