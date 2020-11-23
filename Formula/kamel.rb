class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k.git",
    tag:      "v1.2.1",
    revision: "476ed0e600abe6fe54de19225f8f0c18d6bcbfa9"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "609a4700b9787fbdd4b296d4b2b31b413a5c4afca1ce03ce4f57c1b58ed5c55f" => :big_sur
    sha256 "574dbbd1475b4d45421dd5e6d2705612eaf011c12f24fe0899e47490b51e4399" => :catalina
    sha256 "43663df873f8d797f4a460a2aee38abe8e4fd221111aaa0b53fda75e28f1f4e4" => :mojave
    sha256 "8d546456d8fe9f2435caee683b44c458c61e3ce86957514025ebe90495660edc" => :high_sierra
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
    assert_match "Error: cannot read file None.java", run_none_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", reset_output

    rebuild_output = shell_output("echo $(#{bin}/kamel rebuild 2>&1)")
    assert_match "Config not found", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Config not found", reset_output
  end
end
