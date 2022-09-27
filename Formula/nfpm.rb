class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.19.0.tar.gz"
  sha256 "8b162800b03be04bdc22b83c05d3a1504cb2f2f7d97c84a002e9f503be54024b"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "decea9b1522190b80a904838ddc5082aa27098e43ccef90dfe91837ca485bc2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e24283fb0b2b6e5b50038ce859c553cfe6458a21dd9820e14c530c17c82344a9"
    sha256 cellar: :any_skip_relocation, monterey:       "c87da0d2ad1f57a580f8d23db6e7a538640b1f627d7462ed2157ac4e6b0df228"
    sha256 cellar: :any_skip_relocation, big_sur:        "372fd9a8d4afd15820bde3bd02b1ba75e871f04844999c4eb579ba7f771af5c8"
    sha256 cellar: :any_skip_relocation, catalina:       "8d9e505951f321315d632e3b6d1b1a7b7c593ec3d0eb61694642ad779d3eee97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7d4a6a29ca2b2c3f3947de1b396cf0f8b32f25988372a62089f2d1202eecc20"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/nfpm"
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "nfpm example config file", File.read(testpath/"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath/"nfpm.yaml")
    (testpath/"nfpm.yaml").write <<~EOS
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    EOS

    system bin/"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_predicate testpath/"foo_1.0.0_amd64.deb", :exist?
  end
end
