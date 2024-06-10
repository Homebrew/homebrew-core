class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "873ce3ee1f351afa2ffaebc3a2e0bfb38cd8af198a5b1615d9e43b671f438c1c"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "837e33ba07aae60b30fa9b8c83d9d53a6601470c32deb3f7ac8b9d9fb17e6ceb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e4f266f4b1ad24bb3d87a21ab428e56e68ef1d8837da56887273b71ebf21632"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "970520003348961ddf50d14d405a4198f36b1129535918de2ae7f187b9b10aba"
    sha256 cellar: :any_skip_relocation, sonoma:         "047d17957aa13e81c3141ebd56a6f0513ef1bf0333f8e3753b38b59b45e0fb8a"
    sha256 cellar: :any_skip_relocation, ventura:        "0a6bc0bd127c6eaa2960e301ae5859197d99dd693eb181acddb7880fd9922a9e"
    sha256 cellar: :any_skip_relocation, monterey:       "663f8a6f62783bcb18682043ab43e0c9bef1308929508f15570220ffc09e413e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "264f515d04567cb5cbd094974c498edf8b9052105aeafe30c4f0cc0bab800719"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/cluster-api/version.gitVersion=#{version}
      -X sigs.k8s.io/cluster-api/version.gitCommit=brew
      -X sigs.k8s.io/cluster-api/version.gitTreeState=clean
      -X sigs.k8s.io/cluster-api/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/clusterctl"

    generate_completions_from_executable(bin/"clusterctl", "completion", shells: [:bash, :zsh, :fish])
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "Error: invalid kubeconfig file; clusterctl requires a valid kubeconfig", output
  end
end
