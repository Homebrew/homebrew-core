class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k.git",
      tag:      "v1.6.0",
      revision: "e929db111d6d8ac000f9262342cb3d2eed157aad"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90da83597065617ca2cbe2cfcb1f7684ba701774a7ec5f465dba418fd3dd0f47"
    sha256 cellar: :any_skip_relocation, big_sur:       "247f124ed56bfb76d16a3ba0bec780c019206e969535bbdcf4a2c9ad8d57e811"
    sha256 cellar: :any_skip_relocation, catalina:      "05d8139be2927df577ef13d3955e27bcbd924c253b16c7967adc81b2455bca61"
    sha256 cellar: :any_skip_relocation, mojave:        "67167b34fd58d194e93a81a5393dcd443da305c00516af8fdc85f8b03eafa243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b3bf8afdb6f873e387f6e2903e969b9c8341a0219e781331a1a12c73d3cc843"
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
