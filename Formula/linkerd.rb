class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"

  url "https://github.com/linkerd/linkerd2.git",
    :tag      => "stable-2.3.1",
    :revision => "32825a2a95dcadc5f533eb394627495003e92609"

  bottle do
    cellar :any_skip_relocation
    sha256 "9649c8b96b629618363dc581abbd4149dcefceb05d2d21dad46d482597e1bc4b" => :mojave
    sha256 "f2171d8142e5d6f23b8e0c20abd0f529229a0fc7418a81e3d9b51ac6aac1f30d" => :high_sierra
    sha256 "78ee9b1b3fa583116c74e58a627bdd009d9d44ca74f0ace32aeaf4c7f863fbe7" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["CI_FORCE_CLEAN"] = "1"

    srcpath = buildpath/"src/github.com/linkerd/linkerd2"
    srcpath.install buildpath.children - [buildpath/".brew_home"]

    cd srcpath do
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
