class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.3.0",
      revision: "72aa9d1e68971b5b489aa4dfa4c0687fca0d4f4a"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20af2c73e7c9c5b2e6afe97db4c997a1aa26fd9e87b31769bdce162591532b32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f61b5d4b70d3915cfb7a099d1a7ec83b9037fc520c36749447b123c07335ea6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c35547172310ec21673041835109c3e0dbdfea7d4e89afd5bbcd5d9c9c85ff73"
    sha256 cellar: :any_skip_relocation, ventura:        "49d102c8c2485399751a2776c5fa23244aebc338baf6569f1fc60daf7c72eeb7"
    sha256 cellar: :any_skip_relocation, monterey:       "f2b23d2fb7edb803bca90b6693289a50b9ae4f9378f329cce250dc15bc30c8cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e4d802af5acaeb694fd40dbce0eb127c3a5d847312706b29ba448950010e6ed"
    sha256 cellar: :any_skip_relocation, catalina:       "4da3450e4bd4047883c1958b58ec050f28cf5783f9859de8d7e4e1245cc05e9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ae2f6b405f56d40c27d192f2147110c4d891533b6f3d22f62b5bf602fa0955b"
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
