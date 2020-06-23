class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"

  url "https://github.com/linkerd/linkerd2.git",
    :tag      => "stable-2.8.1",
    :revision => "83ae0ccf0f1aad636764fd0e606ac577e426d3f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0014dc13f18612f9346e16e1e1cf8520560cafddf406fff33ff8778c1314581" => :catalina
    sha256 "c3768f1ebfb56ae0685f7debdd354a79b507f3076fb464480fffd0367d58ea32" => :mojave
    sha256 "9affcd21b8644326642e098fdcdcf57ac083621d709264b630a4fd6b7b685ded" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install "target/cli/darwin/linkerd"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/linkerd completion bash")
    (bash_completion/"linkerd").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/linkerd completion zsh")
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
