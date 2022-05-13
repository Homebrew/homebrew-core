class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k.git",
      tag:      "v1.9.1",
      revision: "501ef721cf1a1ed87bca6257b6ad4af72678ae8f"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d75136e536dd807f1d44c0be1673f7401b64daed8d1c03986bf8420d46988425"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83e73065020926e90822580f30a4aa40e1e3fab5820541058fcd4c09219406b2"
    sha256 cellar: :any_skip_relocation, monterey:       "cdf7fbc37861813135d3e53e39aeef08e104036731c23dfb1c76413be39983d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d8f9d405afbd1bbdb0678c52b008187310d9014dc86b54e547339f8736c58bc"
    sha256 cellar: :any_skip_relocation, catalina:       "e1d8fab7d132fdbf6bcf8c05377736fed62cb685b5ba35f16181fa4ed40910fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f693c7c3b204032e84f00206eb78f769e3e0ae05d40b894c23b726b356d7f914"
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
