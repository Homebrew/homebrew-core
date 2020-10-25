class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"

  url "https://github.com/apache/camel-k.git",
    tag:      "v1.2.0",
    revision: "ab1a566458962b18fef1a1b594efe7d269fb85af"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fa9acf81f26ce32fc964b554c2b1314c3c5eed7158ae505b90a56c7f24ec2cbe" => :catalina
    sha256 "a5d74c1db351e9399770854f859e0de5f6a92aef3e512e391cf1ecfcbd924697" => :mojave
    sha256 "d40704f099605507c7ad82a8571a87b79ce8a3a64b7b6b1cfbec7ffd5c1cf37e" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "openjdk@11" => :build

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("11")
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
    assert_match "Error: cannot get command client: invalid configuration", help_output.chomp

    get_output = shell_output("echo $(#{bin}/kamel get 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", get_output

    version_output = shell_output("echo $(#{bin}/kamel version 2>&1)")
    assert_match version.to_s, version_output

    run_output = shell_output("echo $(#{bin}/kamel run 2>&1)")
    assert_match "Error: run expects at least 1 argument, received 0", run_output

    run_none_output = shell_output("echo $(#{bin}/kamel run None.java 2>&1)")
    assert_match "Error: cannot read file None.java", run_none_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", reset_output

    rebuild_output = shell_output("echo $(#{bin}/kamel rebuild 2>&1)")
    assert_match "Config not found", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Config not found", reset_output
  end
end
