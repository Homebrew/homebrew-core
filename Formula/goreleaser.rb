class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.80.0.tar.gz"
  sha256 "6ecbeeb2b502a9bb5a3f30e88b66322264ef4e0281e0f41d825ed66ef916cc50"

  bottle do
    cellar :any_skip_relocation
    sha256 "8363e95739bbcacc84e01ae003d4a492a9101636102fa7fc9e085e0e1cc292b7" => :high_sierra
    sha256 "70f338d7b12a64b86db356cf939234280f705807e3e1f9a415fb5db5cee58004" => :sierra
    sha256 "e53257b35e9519588a580882437e7c7e5b015aff1e23d797f5375112b6f0a6c7" => :el_capitan
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
