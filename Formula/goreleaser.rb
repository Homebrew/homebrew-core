class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.106.0.tar.gz"
  sha256 "bfbac090828c0eb0c3b6500e226c56082aaba78b83ac21a1794bf8c5a1ce154c"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d6f51436a6e961ff317416da0857f034d1b5829151d74f42f63c7d826602bdf" => :mojave
    sha256 "763e2b50b85d478c523493e2ee8765730c85ac7ce67b0972aa1a772fbb15026c" => :high_sierra
    sha256 "23295c979b7fcf4bef4e6321691b5b1fd48466cc5ccb1ad7f2cb66c7a2cbb784" => :sierra
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
