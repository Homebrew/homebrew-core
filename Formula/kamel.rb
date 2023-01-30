class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k.git",
      tag:      "v1.11.1",
      revision: "06bec9b425fae028b376233f9736f774b0fa840b"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0b929f8b4d7ba65376fbe2d0914687439f6a15c066507b15a87f668fad4aac2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56ca18784815191b73ea9c7cf0ef727a398bb56393ba9679a81a6cee1e2aecbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3871dbf94619608b54e4bb2d290c0cee92c1980618b919c035047b3ee01639b"
    sha256 cellar: :any_skip_relocation, ventura:        "c293036aa73e13efe7d124fb5fee2207253656c3c4bae31be145295f4d366fd7"
    sha256 cellar: :any_skip_relocation, monterey:       "79fb5a67f2d1d71c8bdabb33505a41d1fdaa5701e2419fd889ea609a3af129e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b8f66dac6a10bd79924b5566ed26d0ef41e3469fbb7cd1b52de178b6eb640e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5390e8b95ce6caaf3e026b7e208759dc85cc07b1645880884df104912d755d1"
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
