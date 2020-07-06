class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"

  url "https://github.com/apache/camel-k.git",
    :tag      => "1.0.1",
    :revision => "21b88a3bfc07ae9fd9ff5f129ce3a22f1dfc5318"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "01164390550da7b036a9cd497ad88586e27d5a3aaffb6fd334e4218316c02ea0" => :catalina
    sha256 "34c301e095a815674dc5ef55a0c43a5b57b3d3d8d81cb10172c0099eb56a7431" => :mojave
    sha256 "1c56fdfed7981d65a67690ebc188959b920c17acc31dcbabf484d576937a149c" => :high_sierra
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
    assert_match "Error: cannot read file None.java: open None.java: no such file or directory", run_none_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: could not locate a kubeconfig", reset_output

    rebuild_output = shell_output("echo $(#{bin}/kamel rebuild 2>&1)")
    assert_match "Config not found", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Config not found", reset_output
  end
end
