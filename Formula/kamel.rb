class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k.git",
      tag:      "v1.12.0",
      revision: "5ad94f701e740f8d75dabdb39f897277bd89a84d"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dab5bd7d09f7cb52bf89251e98d90819fc3e3a669fce43e723cb0fcf0ec1cf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48107bcf5143a9400749feb75690b5d87a1c25f9bd9a6581f094d18328bc9a6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b15aade18fd79258d47b945e9070ccf6d6a5750870ab1919e5a12034466a0e09"
    sha256 cellar: :any_skip_relocation, ventura:        "c01e79b531d5ffc6061ac0daa7f3b9b1e2f7e196f2eff9ad8b51d361274d46e7"
    sha256 cellar: :any_skip_relocation, monterey:       "2af10ae4271690669880d91a6515516dcb461a9a1e775e0c42f30449714f8b98"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce45f37998420010c555695df0a0e3f9959884b7ce769c50b5f91edae8522d41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22a9d2a3b6a5e49d468b131f6c263740ae2c9bf6647f0194a775fce285a4a25c"
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
