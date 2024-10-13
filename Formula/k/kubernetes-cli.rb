class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.31.1",
      revision: "948afe5ca072329a73c8e79ed5938717a5cb3d21"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7b2dacab8e24e56d32b556ac18fc628504a9803850f2ff4b309a8eb52f71e34b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd4adf11b477a2d833cff8baf14822329aafe9ade60ecd09456a825a964953ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cbe24e30bd991c27aee2a28423826fadab5ebc15717f51fa25ccfdb0aa9e795"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40d55ffb51ff6c139c53d97b7c57c6fa53598f72867e8ef5e25462ec6b502999"
    sha256 cellar: :any_skip_relocation, sonoma:         "48186c2050ab56624463e272ab9e343fae8580ea5452739c229bd5eb9f37f65c"
    sha256 cellar: :any_skip_relocation, ventura:        "ac93829f01d291ae6138b71f5b92c195fee666c6472a5f7322bc1e341b7a4284"
    sha256 cellar: :any_skip_relocation, monterey:       "08b6aef481e96c36fec30cf8fee213ca0a273210c670daeca5b6a408fc9a7bc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ce9759ac9adcf152d5c77aa64e3d8cd1efebebf6e7e271d44055e105e0f18e4"
  end

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
