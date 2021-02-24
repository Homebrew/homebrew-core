class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"

  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.9.4",
      revision: "f9f385a89ff9765dfc100886537ee9e15efbc3cc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "07a36af650207fe73ad428e9073f9aa4d2be325c2ee9712e4002b765cc451528"
    sha256 cellar: :any_skip_relocation, big_sur:       "c7febb2775499447608d28e889060b2de09aa55be6ad252343c2af485f54fcf4"
    sha256 cellar: :any_skip_relocation, catalina:      "edf4fe6c38dd321d0fc79d719463097454cb7c99cbf915d51a2ab4d21d79e53d"
    sha256 cellar: :any_skip_relocation, mojave:        "5fbc42faf0ffd0e33caf915c030b222cad0c8c5a4d717983a6cb9ab8a498996b"
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install Dir["target/cli/*/linkerd"]

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/linkerd", "completion", "bash")
    (bash_completion/"linkerd").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/linkerd", "completion", "zsh")
    (zsh_completion/"linkerd").write output

    prefix.install_metafiles
  end

  test do
    run_output = shell_output("#{bin}/linkerd 2>&1")
    assert_match "linkerd manages the Linkerd service mesh.", run_output

    version_output = shell_output("#{bin}/linkerd version --client 2>&1")
    assert_match "Client version: ", version_output
    stable_resource = stable.instance_variable_get(:@resource)
    assert_match stable_resource.instance_variable_get(:@specs)[:tag], version_output if build.stable?

    system "#{bin}/linkerd", "install", "--ignore-cluster"
  end
end
