class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"

  url "https://github.com/apache/camel-k.git",
    tag:      "v1.1.0",
    revision: "29d581a49eacb4d191ff665a559fdd569c6deef7"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6569f6598d32c5a0de2174002877cc4c6793bfe63d900195521c6e6239bc51a3" => :catalina
    sha256 "603c0366a0d29dd0f82735431b74d8c70337a5b295c0afa5aac3b9f3fb7d28c1" => :mojave
    sha256 "a2540b8fc6d4ff734590af511c84119c5fb9f7dbd4392c193c46ce11561a25bd" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "openjdk" => :build

  def install
    system "make"
    bin.install "kamel"

    prefix.install_metafiles

    output = Utils.safe_popen_read("#{bin}/kamel", "completion", "bash")
    (bash_completion/"kamel").write output

    output = Utils.safe_popen_read("#{bin}/kamel", "completion", "zsh")
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
    assert_match "Error: cannot read file None.java", run_none_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: could not locate a kubeconfig", reset_output

    rebuild_output = shell_output("echo $(#{bin}/kamel rebuild 2>&1)")
    assert_match "Config not found", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Config not found", reset_output
  end
end
