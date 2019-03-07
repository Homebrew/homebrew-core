class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.102.0.tar.gz"
  sha256 "b8340f4c6f5d285f027eab0dc1cd5f34842ed3daf38fee21e3ff8c32301297b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "6348874c50cc2a0639653c10da4b27b775e3b3d6260c4455a16b3d8239111dde" => :mojave
    sha256 "255fc0aa2acad0c6c7e9ac8b21262e4399f8023d9f88f3d001287d95a5bd56c6" => :high_sierra
    sha256 "f95cd91a07c00b9479d9fac833c905cc25674b771679ca5ada411b9c6b192240" => :sierra
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
