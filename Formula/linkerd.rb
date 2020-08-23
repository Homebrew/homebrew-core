class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"

  url "https://github.com/linkerd/linkerd2.git",
    tag:      "stable-2.8.1",
    revision: "83ae0ccf0f1aad636764fd0e606ac577e426d3f9"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e7935ba4364476f17408883ee28616ef184313141b3bf867741909abcd350715" => :catalina
    sha256 "5e68a496869ae3c8aef8c99331f573e2a49c7fa831584737f133e5efa7784a69" => :mojave
    sha256 "341c693291213280a51bf4ad81281e8428a3c264301be1074ae09395b1b09e66" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install "target/cli/darwin/linkerd"

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
