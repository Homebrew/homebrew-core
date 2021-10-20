class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.7.1.tar.gz"
  sha256 "827cafe1647d68e5db7c959922f83503df7f3b2e06221e184bfa0f53455eace6"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c96419d99b4fd4f9abd0a5fc56d472932df3b8de93a3ef9f0583502be2a8566e"
    sha256 cellar: :any_skip_relocation, big_sur:       "830b51685767b1340fc2bbebd8c694aa095a3bf0b463f63cc5a16ebdc956a794"
    sha256 cellar: :any_skip_relocation, catalina:      "acc1c9f143ae7c704cf30a0af6982b1dbcaa04f66e5cc07b71918f9a8e0a988f"
    sha256 cellar: :any_skip_relocation, mojave:        "acad9d91d9bdccb3ea583f1d4e17fac7d1e2e9964546d311fa858538f32fd293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59322fd2abc65f45e44dfeee49eef49b34b0d05e5de68b6f20570fc986ddabb4"
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
