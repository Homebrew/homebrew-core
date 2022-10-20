class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k.git",
      tag:      "v1.10.1",
      revision: "cd7d3db2aae66f3a5c6ffb6aa5cfa83dfce857dc"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e245636958086a8f2d4113b40704a1cfaac32b18ce15681401a1bfaadfdb273"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5defb3662a5116f3e8bb49ac53b598d1d363e9b78b3e8b361fe7954a2a46a6ed"
    sha256 cellar: :any_skip_relocation, monterey:       "ecb257df057c180c7b0790531e554c75ed0d25fbe3f9942c7f8f3915180f440c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8049820bb1cb63d8c3cb72782154cc1fdd8304810a9fb2220cb15eb5017e88a0"
    sha256 cellar: :any_skip_relocation, catalina:       "b4560b4d759ef6ca5e78c6ade714e39053c34aadea48e04f0bc587fd5ae756c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d199c5a2123eb81ebf9cd74e0695de989e3d5e2dda1508d7abe3f6de62b648a4"
  end

  depends_on "go" => :build
  depends_on "openjdk@11" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("11")
    system "make", "build-kamel"
    bin.install "kamel"

    generate_completions_from_executable(bin/"kamel", "completion", shells: [:bash, :zsh])
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

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", reset_output

    rebuild_output = shell_output("echo $(#{bin}/kamel rebuild 2>&1)")
    assert_match "Config not found", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Config not found", reset_output
  end
end
