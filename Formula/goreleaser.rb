class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.93.2.tar.gz"
  sha256 "cbd31e4c347fdf9f5beed50c841d8c9f453c41a2b2d3c0d054ff5ff954de3ec8"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8ac12c604181a5117200b416ebc8542fdf0470fe4a12fa44309116e70d739df" => :mojave
    sha256 "29c19f9250d5bd4ade799d73aaff348874d29d38967e80ca9962797a9c4fca57" => :high_sierra
    sha256 "afae06694f175e880bb7636552f8058f96cc9db474b31df777fa1518796ef0ef" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/goreleaser/goreleaser").install buildpath.children
    cd "src/github.com/goreleaser/goreleaser" do
      system "go", "build", "-ldflags", "-X main.version=#{version}",
                   "-o", bin/"goreleaser"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
