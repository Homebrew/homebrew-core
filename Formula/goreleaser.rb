class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.83.0.tar.gz"
  sha256 "a2d6a74f31b47b0843147c7b4280830a0373d1e0a2dfd90e15e475a571ca1141"

  bottle do
    cellar :any_skip_relocation
    sha256 "a58580acc26b2dd17415c6c0dfd4a5ac24a282d399235282440ba87389934f8a" => :high_sierra
    sha256 "473c1d62dc4ac7e0456706ee8148c335d93009e192a4592f9fa71113d82f1a63" => :sierra
    sha256 "3cc5a0c12e8f40f0b7cd2e4a55f895016b3b7de86871cc746c07d8a168e79f5d" => :el_capitan
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
