class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k.git",
      tag:      "v1.5.0",
      revision: "9355c0808f5368e5c70bd03535ddaaeb85c6b43e"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "747cf904af90425eb6dffff7a7f6cd9f9e1ac37b777a892eae3cbc3a73c411ad"
    sha256 cellar: :any_skip_relocation, big_sur:       "4e8c1c913c2a70db9a9714189f380124d95dc1627f78c4736c4df13d3ba5a6d1"
    sha256 cellar: :any_skip_relocation, catalina:      "18d3e4401efd0ffc1465fc3bb6337f12342499c350a44d49aa900039000e8562"
    sha256 cellar: :any_skip_relocation, mojave:        "70be9a875b178084c9f7af37152cd83b20d2f2208fde8ac74582840dd54b0ede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd58835f1a6fd97db3bd9b635495bfd8808ded1aa67fe4312a3fb709da2b9333"
  end

  depends_on "go" => :build
  depends_on "openjdk@11" => :build

  # remove in next release
  patch do
    url "https://github.com/apache/camel-k/commit/5385f35485e95197be33cd3684392186fe49db31.patch?full_index=1"
    sha256 "0ab648244ed6e342ac1a1d6ecc878d78e8d0b64b14d872346d29f897e56e6bd1"
  end

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
