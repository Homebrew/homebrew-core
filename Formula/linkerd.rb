class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"

  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.10.1",
      revision: "d71a8291ae80dc5b1e292e6637255a6c3f18db98"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dab52518c3d6c4348643236af6b6a090efa0e6dbc09f557dd75ecdad8ea4858b"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a234b4b47336939afa9534866fb7028196ace96991e26204a8e46d5e83331db"
    sha256 cellar: :any_skip_relocation, catalina:      "1048915adb1c3e3eb5a6f96aea2a098ea7727a18b1391e94f65e295d09df6d0e"
    sha256 cellar: :any_skip_relocation, mojave:        "d0337419a80faadeedd0ed54d95f659bab89b16de5e7102000bbbc191b4c0dac"
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
