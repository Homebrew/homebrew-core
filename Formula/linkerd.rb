class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"

  url "https://github.com/linkerd/linkerd2.git",
    :tag      => "stable-2.8.0",
    :revision => "7a9527bf005710bf90db4b15c35e1f7b059f497d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2524d3d7e38131d29fe508341fd9e019457d93ee90813523af37d534404e365" => :catalina
    sha256 "d6aedab76f0ccf04f286c2d595b2fccd6808bbd7a635d6db9d9facae6b00cb71" => :mojave
    sha256 "ca2e21fce5fe672a7587ea31724e8945ed5928c138692e31a8078754021d24a2" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install "target/cli/darwin/linkerd"

    # Install bash completion
    output = Utils.popen_read("#{bin}/linkerd completion bash")
    (bash_completion/"linkerd").write output

    # Install zsh completion
    output = Utils.popen_read("#{bin}/linkerd completion zsh")
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
