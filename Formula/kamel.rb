class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k.git",
      tag:      "v1.8.2",
      revision: "3d22f48f909f99daf2a5d50c9cd518267f984616"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a44a42d1828d68e38c603f9150b7ed14a8e5726d5d3d260803e92f1b42ac7363"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2ef5195a2aa1ed8b0997e5115cbc5549840af60f3073d05f5fc6abdf61fc374"
    sha256 cellar: :any_skip_relocation, monterey:       "8b726717247ca42b12e8fa9564106fea8dce5ac3eeb4d189709f16c24da5a087"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7fa06f538c67fdef00d3b75f5c9dd5a8ad2825895e2a5d272c41a434e2ac081"
    sha256 cellar: :any_skip_relocation, catalina:       "319129766d0e75ca1961b49aaf57be6d029d31dbc29eb134f44b348b30359dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6818471e7e687205a370d4c3ce7a4e3c55be4a86041c9d32fda20f5d2faf489"
  end

  depends_on "go" => :build
  depends_on "openjdk@11" => :build
  depends_on "kubernetes-cli"

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
    assert_match "cannot read sources: missing file or unsupported scheme in None.java", run_none_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", reset_output

    rebuild_output = shell_output("echo $(#{bin}/kamel rebuild 2>&1)")
    assert_match "Config not found", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Config not found", reset_output
  end
end
