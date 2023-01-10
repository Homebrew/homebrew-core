class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.3.2",
      revision: "18c6e8e6cda0eaf71d509258186fa8db30a8fa62"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api.git", branch: "main"

  # Upstream creates releases on GitHub for the two most recent major/minor
  # versions (e.g., 0.3.x, 0.4.x), so the "latest" release can be incorrect. We
  # don't check the Git tags for this project because a version may not be
  # considered released until the GitHub release is created.
  livecheck do
    url "https://github.com/kubernetes-sigs/cluster-api/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86c1a72d3776588a9a4dfc8b7f6f51f32ac1dff802ad451e477ae099c2b551c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b557a9132850a07d828cbee065d72c1724c3ed4f09dfd540c9aac2b0ea05ad25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dc0f53967183fe6a152eb5cabfdccd8cc461f9e3ecca32f48dd205cc14e7be4"
    sha256 cellar: :any_skip_relocation, ventura:        "14eda6cff6873f77756720bbd5049b5bd87a584dc82a68f4a82dad6697deb1f2"
    sha256 cellar: :any_skip_relocation, monterey:       "08d39aacb5e001d330089952835bfa034b8ab3d5957729688a1b109a38ac9bd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "dac8129afe140fbd19cb3c3e40978c8cead041a00633b2357efecee55012be4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf609f969f2b27812293a944bd96782727a95161f70da7002638db2788281811"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "clusterctl"
    prefix.install "bin"

    generate_completions_from_executable(bin/"clusterctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "Error: invalid kubeconfig file; clusterctl requires a valid kubeconfig", output
  end
end
