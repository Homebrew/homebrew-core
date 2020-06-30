class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"

  url "https://github.com/apache/camel-k.git",
    :tag      => "1.0.1",
    :revision => "21b88a3bfc07ae9fd9ff5f129ce3a22f1dfc5318"
  head "https://github.com/apache/camel-k.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ec8586715a660ab0b640c842e582db9cd7c5a533c0cfe6d8adf6b794018cbaa" => :catalina
    sha256 "56c045f37e84b5bbad71e9eb46fedd2e7e4db914a6212d46276b06dcb0cb5403" => :mojave
    sha256 "ba15c2fb6f75861c545c2a4c013b855b49a3238f352afaa5c71ff3437f297405" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "openjdk" => :build

  def install
    system "make"
    bin.install "kamel"

    prefix.install_metafiles

    output = Utils.safe_popen_read("#{bin}/kamel completion bash")
    (bash_completion/"kamel").write output

    output = Utils.safe_popen_read("#{bin}/kamel completion zsh")
    (zsh_completion/"_kamel").write output
  end

  test do
    run_output = shell_output("#{bin}/kamel 2>&1")
    assert_match "Apache Camel K is a lightweight", run_output

    help_output = shell_output("echo $(#{bin}/kamel help 2>&1)")
    assert_match "Error: cannot get command client: could not locate a kubeconfig", help_output.chomp

    get_output = shell_output("echo $(#{bin}/kamel get 2>&1)")
    assert_match "Error: cannot get command client: could not locate a kubeconfig", get_output

    version_output = shell_output("echo $(#{bin}/kamel version 2>&1)")
    assert_match version.to_s, version_output

    run_output = shell_output("echo $(#{bin}/kamel run 2>&1)")
    assert_match "Error: run expects at least 1 argument, received 0", run_output

    run_none_output = shell_output("echo $(#{bin}/kamel run None.java 2>&1)")
    assert_match "Error: cannot read file None.java: open None.java: no such file or directory", run_none_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: could not locate a kubeconfig", reset_output

    rebuild_output = shell_output("echo $(#{bin}/kamel rebuild 2>&1)")
    assert_match "Config not found", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Config not found", reset_output
  end
end
