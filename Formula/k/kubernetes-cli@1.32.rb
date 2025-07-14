class KubernetesCliAT132 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.32.6",
      revision: "036f7ed3f1f4a2d97a654269a98ad7be7d460db6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.32(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31e8ec864258d656b66dd0457a964ac7bb6733c72a704741b850160585ce922e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d180576df273b17d0958898ef37bf9212aa462e13ed7aa2106fad7bb9bbfb231"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0d0f95b5ada11bb2247c7a92ce8a91c2fb9ad23e9a0c435cc648b7a6e10b8e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff48e328423beda52fbe463845580aa99205e621be7ad023a4014e8dbe96d502"
    sha256 cellar: :any_skip_relocation, ventura:       "9937193b927f1fe3fb6fa7f4e20cc8b708e3e63b99f60cd00d191b64c2550552"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac00342871513c8cb7575504e99d27e9f1d138c2e1590dbdcd210b9c0524b04f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4db772b444502cf9dd84e5d24952ae09355f08176776ede197185fbbb02f3f9"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-32
  disable! date: "2026-02-28", because: :deprecated_upstream

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

    generate_completions_from_executable(bin/"kubectl", "completion")

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
