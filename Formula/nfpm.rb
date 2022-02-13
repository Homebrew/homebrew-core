class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.13.0.tar.gz"
  sha256 "aa44d20f653b85484472261dd064e08352ea836d2e639ed7b96ac84d9acf5d7e"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eec6000679a1e24dab49c5457cdf686ed8312c444f97920cfb8660e36153f65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57fea2df6f221a1de3eacde313e85b3353d41b553e8b1678f27107d5a77ab968"
    sha256 cellar: :any_skip_relocation, monterey:       "752f92315ebb10e4711bd9691dd9933d5c337a3a1b97667dd746ab675f6a3407"
    sha256 cellar: :any_skip_relocation, big_sur:        "452726d17c2539e2c28daf203415d026325f9530e9027aeaa85c60feebc67be8"
    sha256 cellar: :any_skip_relocation, catalina:       "181ea98d8baac1e5625dcc0f77d2784ca34d68d8258cb314afbab6ae4f175f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0b8bfecf8474698c5a1e96153f67b7b24574a72e254df2205b585858a304b24"
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
