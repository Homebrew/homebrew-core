class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k.git",
      tag:      "v1.10.3",
      revision: "157db0c33fd26cfad908f2cbb7369b8acedda091"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6d23938da89a8632bd8223609af98e9bec37a78824be81ddf8f4a1d3b26865a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a0197108bdaee3e5889ebff8ab1df04b30d3e581ac84b3a5f61692a786175f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4121e27f6788d77413424dae8d4cc4a5a4768879f3f6f13de6fea34f8387f8cd"
    sha256 cellar: :any_skip_relocation, monterey:       "d18cccbf7741628f69f4f249c9d854fab4389a4d0b7f3c00db8f8ec475a4a6aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "32a70e2023df1dd27a336f7aaee2a4533bfb56cd8888b260032efde10752440f"
    sha256 cellar: :any_skip_relocation, catalina:       "c7fc4068577cbc55211692c3aa36541453dce1d02a4bbad077decf7a30511d8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d681205ce6fbd7d341e400a72fa930d6b087f76f852ce507f27ef6709676f0b"
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
