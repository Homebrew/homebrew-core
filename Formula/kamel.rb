class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k.git",
      tag:      "v1.12.1",
      revision: "f2543a9f6269aad3cc24de3061b130c0e7590c09"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d6184b11a8019b5da49e8f4df5c3b2e3cbf4c8eaeffce8566f6b57d29900448"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d6184b11a8019b5da49e8f4df5c3b2e3cbf4c8eaeffce8566f6b57d29900448"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d6184b11a8019b5da49e8f4df5c3b2e3cbf4c8eaeffce8566f6b57d29900448"
    sha256 cellar: :any_skip_relocation, ventura:        "3d0ad96f867b26eb34d61ef7e6dafabb9a5bcf43427161809865dc458a1a14db"
    sha256 cellar: :any_skip_relocation, monterey:       "3d0ad96f867b26eb34d61ef7e6dafabb9a5bcf43427161809865dc458a1a14db"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d0ad96f867b26eb34d61ef7e6dafabb9a5bcf43427161809865dc458a1a14db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ab411a3f71c48d2a7cdb1468c259f26a60335bc188e682a2828a96b2dc46856"
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
