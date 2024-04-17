class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.7.0",
      revision: "ce58362fefb10c2c9e462a9a6c850733f4d87161"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cea33de4145612086c837d3df169692294c0b5deaf686fab9991a1ca3063b158"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31db238510004364f3d421ec0dea7e213381399318e53a659076101a5042f62f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c37d8fe165d525e599a68a8d69a054d21e1190387f5b8309027ce6d1b2617fc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2fd27527ecd9986ffad8fd5f949b429f70d34cbe142b85e83fdca49967944f0"
    sha256 cellar: :any_skip_relocation, ventura:        "8c2462a420925813dbdcfc5583aa6602175005722efa0c355ce68c66c9bdf039"
    sha256 cellar: :any_skip_relocation, monterey:       "b901806b3858d53734fbf80e78bf6d42ae84064428e724b745b85484f135bcd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaf1c68548f1072870fa66a3bc78f81cfd159cb83fb652113ba7d5102d4a48dc"
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
