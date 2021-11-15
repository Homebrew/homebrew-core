class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.11.1",
      revision: "43fc40f545b47bd86c6800bf3895745f15902e72"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bde5d2dd52573c634ef91823ac631dec8cf89a610fa51dbe9db462679d9395f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d8141e6509d626dedd542f3c88fea07576f95ea89d203bd733e947953af5a08"
    sha256 cellar: :any_skip_relocation, monterey:       "64774dfc513b24364f5504ac1fd53a605e8ab4d94affb61a3b56d756cede67a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "3882a73111e96f2e17085e54bae4af320176bb1312d0de291668a339939ce841"
    sha256 cellar: :any_skip_relocation, catalina:       "ba12910b995f95847d0c92f340cd18e92e9b55cac3b2d48ea92614c2c7c97a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17833ad0395edfe65a3c819bc2826aaaa2ab6d8f84022c14684f5c8f89dc14d2"
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
