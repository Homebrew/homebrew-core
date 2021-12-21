class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.11.1.tar.gz"
  sha256 "227f09e8ead26079d4d60e6181c80dc73b6353ca57a1877cb7b2be8a881cb741"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b3ec28b011bada534527a8062a2a917a88e81efcdb7bf15ddeaf840bc4eb7e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b09f40b4b2e3b7da20349faa8454f03d454ef74b8d924d967dfd7718ab65cc89"
    sha256 cellar: :any_skip_relocation, monterey:       "b5b789861fdc9fdfcbd46d963102aa4739c4664d3f0525780c7c28c557f8ee43"
    sha256 cellar: :any_skip_relocation, big_sur:        "2eebd2f1fdbed4b0fa84bf61654a3cc01772ef408057d8cd17ecab57d74d26dd"
    sha256 cellar: :any_skip_relocation, catalina:       "e9456a693fc837ec2e2314c47a5f3d55894bbd97dfa5a2338c41c4fe37ac3e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcc44378c358e5b52004d000f6b669cb6c804b1e7bc99ead9a2e8db230cb8792"
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
