class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.18.0.tar.gz"
  sha256 "56a3b1ddd50bcd7512b08c1b0b15331a4724908bf2d22c228f05ddec7bf61a75"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b036e248314ed0b2c0d87c238a431de14b3bcaeca12820c97c0868606f8776e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86cd9beca8417d1b39a158bf17c123ae0a645c5db798e82662480fffe0296dbc"
    sha256 cellar: :any_skip_relocation, monterey:       "2d227091696e9f6e5e10d43242066a41d275e66232664ebe01e724e8f9cf9c30"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7c84172e26d7d2398557c7e91b889da253f5b59fc89fb494601aa632f981ece"
    sha256 cellar: :any_skip_relocation, catalina:       "06262df845c101ccfb8f403507d376089d7d227e7d5171c7b9aac87d6ba4392b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a49d88a164d5ef9f0f642b569fa264e7c4ad305f0517ffa9d79b90238f5809a1"
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
