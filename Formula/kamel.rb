class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k.git",
      tag:      "v1.4.0",
      revision: "4e7c313e87f7f808dcf5cd3182dcacf8874618bc"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4ed5bfb0a281e87e0453e4a5fec0d18dd86685ae974a84b9cec35f50f5ff6ef2"
    sha256 cellar: :any_skip_relocation, big_sur:       "dcb66f55f2212852376f433f6dfcaf40b5f520c2018b7a353d9d002b933b1092"
    sha256 cellar: :any_skip_relocation, catalina:      "bde7a6651e566935bc753713249e8b858846c84ef3104a1965336f9bc26c0c73"
    sha256 cellar: :any_skip_relocation, mojave:        "f3c5e8aacf4435e5cb7c3a75f9af9382087307e23ba837525c7e60375eb105fe"
  end

  depends_on "go" => :build
  depends_on "openjdk@11" => :build

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("11")
    system "make"
    bin.install "kamel"

    output = Utils.safe_popen_read("#{bin}/kamel", "completion", "bash")
    (bash_completion/"kamel").write output

    output = Utils.safe_popen_read("#{bin}/kamel", "completion", "zsh")
    (zsh_completion/"_kamel").write output
  end

  test do
    run_output = shell_output("#{bin}/kamel 2>&1")
    assert_match "Apache Camel K is a lightweight", run_output

    help_output = shell_output("echo $(#{bin}/kamel help 2>&1)")
    assert_match "kamel [command] --help", help_output.chomp

    get_output = shell_output("echo $(#{bin}/kamel get 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", get_output

    version_output = shell_output("echo $(#{bin}/kamel version 2>&1)")
    assert_match version.to_s, version_output

    run_output = shell_output("echo $(#{bin}/kamel run 2>&1)")
    assert_match "Error: run expects at least 1 argument, received 0", run_output

    run_none_output = shell_output("echo $(#{bin}/kamel run None.java 2>&1)")
    assert_match "cannot read sources: Missing file or unsupported scheme in None.java", run_none_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", reset_output

    rebuild_output = shell_output("echo $(#{bin}/kamel rebuild 2>&1)")
    assert_match "Config not found", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Config not found", reset_output
  end
end
