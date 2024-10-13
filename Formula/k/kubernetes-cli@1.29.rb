class KubernetesCliAT129 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.29.9",
      revision: "114a1f58037bd70f90d9e630e591c5e52dd9b298"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.29(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "825162b8b3a8320b76141e69ce58e7d1cc75941bc105215f39190a1d944be97a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5d3a71c54a5c040d9dfdacd0484940b499858bbfbe679071ae877d88bc7c5f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68fc40f300cc8e0d8bf9903d3d49506fbc6d178d11301178e0b07a7c5c6ecfdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d714e41181cb8ddbb03915fabcb061c40fc081ab3a8d3c237a336d466ff33db"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fc76b060d7b81efc537a2af2626d705321cdc52e10046500d1eb63332d7bbf4"
    sha256 cellar: :any_skip_relocation, ventura:        "e94042ba85828eea215df44469314dcbfc13a96c6618c1dbce1fc42a5fc9827b"
    sha256 cellar: :any_skip_relocation, monterey:       "4f4de36a18c478e123b330db1cddd0135e5e91fafa861f97fdfb9a0b3d37bdd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efbc027439945f906717159bc91505257f94d41c8767099391d1a71b3bad33a2"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-29
  disable! date: "2025-02-28", because: :deprecated_upstream

  depends_on "bash" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac? # needs GNU date
    ENV["FORCE_HOST_GO"] = "1"
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", "completion", base_name: "kubectl")

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/update-generated-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client --output=yaml 2>&1")
    assert_match "gitTreeState: clean", version_output
    assert_match stable.specs[:revision].to_s, version_output
  end
end
