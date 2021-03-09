class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k.git",
      tag:      "v1.3.1",
      revision: "b705f57d2503505388e40931a8c97ad50fc2d346"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c52e7f5e007e12e4c191db92ed779e7aded3e09a42284871a50c52fec108c311"
    sha256 cellar: :any_skip_relocation, big_sur:       "5e07672ad25869206e8d43c1959426411b6f1a410e44e4e2279271e07c542684"
    sha256 cellar: :any_skip_relocation, catalina:      "982c51e01f8e5bf9fb867c5107428ffe3ef000400c1d9cdc9c5710d50d4f194d"
    sha256 cellar: :any_skip_relocation, mojave:        "356cffa21363864841e10ef0073c6a6ce25d215a7cc728d246e0953c896dfebf"
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
    assert_match "Error: cannot get command client: invalid configuration", help_output.chomp

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
