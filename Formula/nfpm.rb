class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.13.0.tar.gz"
  sha256 "aa44d20f653b85484472261dd064e08352ea836d2e639ed7b96ac84d9acf5d7e"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a47441178cd4688ed78949da62602184816d82cd5d2e5989c609711df5290617"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9ba9de356d0d26abd09ec2a530b5646bd674d3ed67c45bf6e29ab8effa1b48f"
    sha256 cellar: :any_skip_relocation, monterey:       "96f1f2dbe459ae8f30af48d00954b785c01d7cc2c86f810826f60c0a6e03abbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "e27f48063f175e4aad5126b304d27e32e16e1b89cbf4ef57111584afb8075f93"
    sha256 cellar: :any_skip_relocation, catalina:       "24178311415cd7fe56c71a63ed08bc5596f7ed744b3945bdf5e39a8d5efb76ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c98c04031d819ce1e4dfbf9004d4a52e8f695592a0fe5f5a78c2a93fbc04d97e"
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
