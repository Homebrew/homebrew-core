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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa2cc0231913e380c326a9a442a5bcde3aad72601c8af37e8594551b80b8bc6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc3a4d4f50ed082625fe5ee9f525634696f5f676de4ed935b2a21de5c024cf29"
    sha256 cellar: :any_skip_relocation, monterey:       "828047d9df980e421cc9f86161a3248ec9b520fc68481e68eaa1cdb7fdc90e3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d6ec6842ece259e50d3f8375a9273a872116589f65fd686133953aa0d75a5a0"
    sha256 cellar: :any_skip_relocation, catalina:       "cdf6f2b72ff8dbfdabeec4ccfbf292f815316c3f97667ad43016159a0f53a111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14b06e7e5b1fe878ba0e6a952198702493cb68842115f82971bd401994a3a28a"
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
