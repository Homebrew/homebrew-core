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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f70cad2df9536eeaf8b62831d1277702abdead94d60b4a03d2efe69a4205d011"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f70cad2df9536eeaf8b62831d1277702abdead94d60b4a03d2efe69a4205d011"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f70cad2df9536eeaf8b62831d1277702abdead94d60b4a03d2efe69a4205d011"
    sha256 cellar: :any_skip_relocation, ventura:        "d14617a747d236d2e38b43954eb80cd4c899df0efd3ecceb0db89515d35dadf5"
    sha256 cellar: :any_skip_relocation, monterey:       "d14617a747d236d2e38b43954eb80cd4c899df0efd3ecceb0db89515d35dadf5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d14617a747d236d2e38b43954eb80cd4c899df0efd3ecceb0db89515d35dadf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eff5f1edcb4f9b5253e5cf53ef1e0e3ae1eb9d04de54924024f103d1dde6f9b2"
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
