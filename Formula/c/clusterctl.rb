class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.5.1",
      revision: "db17cb237642881cde3e3f61e77eca55e2583883"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api.git", branch: "main"

  # Upstream creates releases on GitHub for the two most recent major/minor
  # versions (e.g., 0.3.x, 0.4.x), so the "latest" release can be incorrect. We
  # don't check the Git tags for this project because a version may not be
  # considered released until the GitHub release is created.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "febc77849acbdd65f734dc9ae7c8ceec6cc655e12780f41bbdeba4f0759fa5c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8254be7116449ac8a092d7a9ce1b8413afbf013b3ea8eb5a8258b3c5ed5eda9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "441367d5e02a0a3cc277d8fefcae7552c792f93c522a4ae21d73ef99358b376a"
    sha256 cellar: :any_skip_relocation, ventura:        "b2d3c24e45c99b88eecd1252c5fda1cb3d999bd26963da6e3dc78d16dbf8564a"
    sha256 cellar: :any_skip_relocation, monterey:       "9c146eaa1cdbaf196bf7796f5a474d617c3e5bea4f358d71af87f5bd6b865dce"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2b652a3cf15e62e7ea6ada99fb6f6dd252720d53e3416aa8ad124fb3dce3312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abcaa6a2a2cf58b7c72ae8b6631cd29f188f4236d408acb388a7dc2aed5d1c4c"
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
