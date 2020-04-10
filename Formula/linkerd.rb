class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"

  url "https://github.com/linkerd/linkerd2.git",
    :tag      => "stable-2.7.1",
    :revision => "4a91892387d422755e66a76995ecf77f060a06e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "70d055275c280f4bdfd62aa95b79a1d3e68ec87de26fda2927d1902edb16dc90" => :catalina
    sha256 "689913101115c9ad74e97cba76160e68ba92bb58d7384cf7e42d0faa23533bd3" => :mojave
    sha256 "588139f4dc9bc11cb7f4230d44a154c9a50ce924f2a36b556ad90a5b0c5ce714" => :high_sierra
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
