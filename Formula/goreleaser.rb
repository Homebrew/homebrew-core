class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.96.0.tar.gz"
  sha256 "26169a87889ca897012948c35206de497dff30bc1c48ecfb315a3e08585fc8a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdee2b75b5e850669da21a7a8723f911ac8aa3ecc710d2802831e8b47710fe89" => :mojave
    sha256 "04bcf5fc9c3cee9893d5404a7953009093ce60f928cacb53b1a8fd4781b0345b" => :high_sierra
    sha256 "6eff5229e93ce17f8c5d5084b824e0cca51c6c8d6ae3f1f6d2029e4fbe69115f" => :sierra
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
