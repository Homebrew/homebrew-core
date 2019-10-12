class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"

  url "https://github.com/linkerd/linkerd2.git",
    :tag      => "stable-2.6.0",
    :revision => "1039d82547388f361160b419e30d0b6b2051dc36"

  bottle do
    cellar :any_skip_relocation
    sha256 "63070c49d191ed275816e6ecb913367e4548426368009955e85f509ed76a9c96" => :mojave
    sha256 "5ca9da578cf3606a63febc4fcd1ffe11113dad24d05a20323991b543e970f7d2" => :high_sierra
    sha256 "c4fb12ef021a712d2354f7956127ccdf91a5ed679dc306dbe16158351f7be182" => :sierra
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
