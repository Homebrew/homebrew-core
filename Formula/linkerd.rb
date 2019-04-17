class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"

  url "https://github.com/linkerd/linkerd2.git",
    :tag      => "stable-2.3.0",
    :revision => "e6a29728c8e3796c6acd4c9f9a17b138d51f147f"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddfae347c3ce857800db345c4ae6fe7bcea27281f949401b1a42e8e334cc2420" => :mojave
    sha256 "9b7011b58a5cae0fb2ab52a68fd9eb36c687d3e675f25976aee50217a58cab4b" => :high_sierra
    sha256 "1d0b1ac54b47c3f7a235b78619e081871eed029b00ece0886210dbd74ed9bf17" => :sierra
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
