class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"

  url "https://github.com/linkerd/linkerd2.git",
    :tag      => "stable-2.6.1",
    :revision => "876abf021b7682dea9f5641ac84e42612647e419"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f44204a36b547abeb63f36b69ab601473ce409d971b8e3dfdd01c64130db1d7" => :catalina
    sha256 "b41f554141276b8c61508a155df52f2f600189408f1deabdf629258bc25df494" => :mojave
    sha256 "023f2106ffe2216f7c74967447d5a4a9b1db9d20a304fb7573d879b184f27f23" => :high_sierra
  end

  depends_on "go@1.12" => :build

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
