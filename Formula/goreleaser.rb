class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.77.2.tar.gz"
  sha256 "7079816c2527cf7d1585c4e80ad88b54486395e913128bf9eb628ea2199f1d6b"

  bottle do
    cellar :any_skip_relocation
    sha256 "31a39769408464b31c3237093ad6694a4e003691aa547de79d87e0d73f242994" => :high_sierra
    sha256 "806b62effaec19eba19063d2407a25ad1ccbaa4b90b514dfeb8fbdbd0b58be4d" => :sierra
    sha256 "1f65fba8be7c0138a4cbaaa7c6b9185b44eede51dddea4d8d2ddeb75a63c6ffa" => :el_capitan
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
