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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6395280b247d5d6cb383469139564fc88ab32a39b9caaaae0a97b29c76d1edaa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c3d541ec7cc9c47a254b131dba627c042930837b18942cd010bce151bead0be"
    sha256 cellar: :any_skip_relocation, monterey:       "4ad68daa5047ae1a3a9f0b7f536d84b59d9365e3f9ad91571f309ccf93d45b09"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e6611199117702d301594d01b5acfc5af9038473579844bbefacc787192e587"
    sha256 cellar: :any_skip_relocation, catalina:       "08f1c0ecef398baa2cd49594c07bb3da547da3b0f5bfd23eebf3c6e347a80a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4628e40b20eba1ed65cc16fc89a1a5c7a563b79c99ece281f3766f3c0a6ea7b9"
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
