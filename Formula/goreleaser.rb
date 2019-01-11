class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.96.0.tar.gz"
  sha256 "26169a87889ca897012948c35206de497dff30bc1c48ecfb315a3e08585fc8a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2424f92632d615fcdb53880beb2546e60b327917f91dc967e378e214882ef06" => :mojave
    sha256 "e542abaa9f62c361e4440cd3541a366d09d8513d46db7e134dfd9a9e62280f07" => :high_sierra
    sha256 "f53cf3559d5508a554f0342d461ecf8fbcbbf3a11fd85c82d3c4dce6ef3a9fdc" => :sierra
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
