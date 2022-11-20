class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.2.5",
      revision: "cd87c3d90245c2fcf947cfe9fe0d8b7205746b7e"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3158a252bf442fccc4e5f7446769a471e7714bc33567f8af9e3f41ec9914aa58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55009e5b151760fddac71456c2ebbbb3a09b5688e08df949305ead6ae5a2bfaf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "487d52e4ea803d70082768c18fb7beb0c39e572a1552a1e25c5694744e48a1f6"
    sha256 cellar: :any_skip_relocation, ventura:        "3523d51ca671bd794fbd046539ea25a585748675d7fdcfdbb0bc1176e6a75d62"
    sha256 cellar: :any_skip_relocation, monterey:       "11ea1cd61f468935f55b9ae7f4d11837bcab02c6fe75b0d5b40bde29df6bb1a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "150e28efb7a5559c993805f7beed9b814c3961190626aac3114a6322b7ee3475"
    sha256 cellar: :any_skip_relocation, catalina:       "e68df341d8000dd9f442fad523e81b50a97936efa86fdc42bdfffb83d3c440f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4d64db63f13c6775cc6fe1f019016734267a32efddfa305271349a5f217f18a"
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
