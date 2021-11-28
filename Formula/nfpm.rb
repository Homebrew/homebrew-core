class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.10.0.tar.gz"
  sha256 "8de4e2f4224ee209c24afb3d7fac9720e8f296cd8009ce43160a5526c41490f3"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "246c6d427917970962075e8356751bdf26b4d61702b7b3d3ee791337b9824252"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a2a507a504f4ab759ae64d04045a716140afb80602640307d884cee2f6d96a9"
    sha256 cellar: :any_skip_relocation, monterey:       "974c44048451b60a582386265866e4c7bbf8d5f49897ec6ab102b74138a10948"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a3f7f00ed980e0c64c69cc276e20777e514f6b6ab0f27b5728c5fd75c563fff"
    sha256 cellar: :any_skip_relocation, catalina:       "690d1b987921646311b40f7655a88e8a283ddb7065d7d41d1bdcebe3f8779c6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a39707115d896117be3fec23fee0c68c5d5bd584bb6732db9d1a3e5728e98467"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.version=v#{version}", *std_go_args, "./cmd/nfpm"
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
