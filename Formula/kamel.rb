class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k.git",
      tag:      "v1.6.1",
      revision: "7f1a34f473275b3c40eb0e1c369901c030a71c93"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c5d4f1ab9b49df2038e7b194c025209c73ebec4b19593ab3dc669914ab2fdb3a"
    sha256 cellar: :any_skip_relocation, big_sur:       "e053362633c04b93786d30df6d191aa740e1461acbbc180e84c49e39fecdcedd"
    sha256 cellar: :any_skip_relocation, catalina:      "0ec32a5a191e484fbc33cb33beba54c81cf919188528cdc21de42cd1e749fae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70e07d9beecff17e3943e7f2ee70a7f7e496cf07d011ce1863556a2741946aa4"
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
