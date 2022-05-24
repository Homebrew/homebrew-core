class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k.git",
      tag:      "v1.9.2",
      revision: "405f535a9fe6f1f051ae2f5cd11c6b447e3d9e1c"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da4dc13e152e87e162e6bc21519e76a52f11b082daa3fa1fa176ba6fd0dac4ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0dfa513ca886c9363ae2a0488e2eea88599b85ee2612b4d9f3e622de49fba889"
    sha256 cellar: :any_skip_relocation, monterey:       "123bdf5d7d7f77efa28753c5568054da4ad743ee320d16912878b0279be1a5a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a8b32e9c0e651a63c0dadd655f70c709f03e2cfe5f6ae1da5a33fd4775d4a39"
    sha256 cellar: :any_skip_relocation, catalina:       "e4ecdd5d8d42e460e42a4301066f3adc10951f726503da8d1015acb2a6fb8b12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c583c5cc8c24b18347288d175c1951a921ceb74d2216ded9608c1aea3760b5ff"
  end

  depends_on "go" => :build
  depends_on "openjdk@11" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("11")
    system "make", "build-kamel"
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
