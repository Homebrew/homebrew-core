class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.20.0.tar.gz"
  sha256 "d547f7e536e64a571928b443da100005d51eba7ba59caa6c490cd577b31f8cd7"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3726745e3ed6b4b556b654806e21966ee0a0b7a4f40d698a7105b2e99da2c6d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f398aadb7ca98203c019283d668af73352aed5156e53ee21c1a6b6cec14259c"
    sha256 cellar: :any_skip_relocation, monterey:       "af72de55c3b50a9e7dffc640cbcb76508667f6e757d96eaa6fb0eb15566f0ba3"
    sha256 cellar: :any_skip_relocation, big_sur:        "5189b64cbc85ec303aa605b2f61224d7992860cb0f8abdcd5594f18902ed6bab"
    sha256 cellar: :any_skip_relocation, catalina:       "486782caaeeb05578561f988ae5f6c7bdcf9041ae5b2b244ad50bdb9f2910210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60932139aafa1cc23f369fb50884d53692ad1b07ebec05bbec44f77b859f7f1c"
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
