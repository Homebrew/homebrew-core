class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://ashishb.net/tech/common-pitfalls-of-github-actions/"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "674029ba6af49294147d7f5b3757d4e3eb0c5e0e23e44883410f7b233d678679"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "911a07960c165a97b649cf9f1e5af32903d69975a0ffc7ee50555e2aaf09fbef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "911a07960c165a97b649cf9f1e5af32903d69975a0ffc7ee50555e2aaf09fbef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "911a07960c165a97b649cf9f1e5af32903d69975a0ffc7ee50555e2aaf09fbef"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "83a74c9369920a9f039ca9ace4582e4ac37c65c833bda61b795be6d6be9d5662"
    sha256 cellar: :any,                 x86_64_linux:      "1400d3b192b2399d84f9b0547aacf3380dc60ac54842bf437da9bf96328e695b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "src/gabo"
  end

  def install
    cd "src/gabo" do
      system "go", "build", *std_go_args, "./cmd/gabo"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gabo --version")

    gabo_test = testpath/"gabo-test"
    gabo_test.mkpath
    (gabo_test/".git").mkpath # Emulate git
    system bin/"gabo", "-dir", gabo_test, "-for", "lint-yaml", "-mode=generate"
    assert_path_exists gabo_test/".github/workflows/lint-yaml.yaml"
  end
end
