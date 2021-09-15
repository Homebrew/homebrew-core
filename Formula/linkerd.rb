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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a9004e38d4498ea9ab12751777ba4284ed219338aacd197a58af3e69d65c91ae"
    sha256 cellar: :any_skip_relocation, big_sur:       "1dfd678ef51501dac82b9c51c0473d0c63731f15c59a831fcd5986929b796e94"
    sha256 cellar: :any_skip_relocation, catalina:      "6c65d4ad2f236925e1bbbbbce61819bc935d26b835c5ed5b46a7f6caf156c5c3"
    sha256 cellar: :any_skip_relocation, mojave:        "4331a8af8fe790fde28a085b60f40d45094a78bdadeb8c56e6890bebdde40e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb421d8ac0f1e159fdd152199a3fcf01aa509a21fd0cccfe6bb3429552eb5eec"
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
