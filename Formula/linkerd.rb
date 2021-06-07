class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.10.2",
      revision: "5535e9c4edda7f5a8d8d21e351b61425bd3a8208"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "63caf6acb6be47d6ed96f53e72382007852cc6c7c14b815817422201f29df358"
    sha256 cellar: :any_skip_relocation, big_sur:       "cdb2f8d77286219fbea6c3601ca2bd96f059c396f62d4e17f9e6ab0478ad57fb"
    sha256 cellar: :any_skip_relocation, catalina:      "2e9d765a3dfc391922b57948e52baefd835b271419c18e6cbfd5d95b3a2f5b0e"
    sha256 cellar: :any_skip_relocation, mojave:        "374aa4fd37cb80c413bad668cd50c12d4d293213a3aec35743f1a48cb2a6259b"
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
