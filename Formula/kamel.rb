class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k.git",
      tag:      "v1.11.0",
      revision: "13ca5a0570e81e7c03a911ae785bd1a73bb6b7e5"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74eebc398ce4445577cebfc79727785770bc6b7dec226d2eed1326295deea927"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be9c9208581b0d8e29e5ab8e7603c890a60b3742f7d55956f9729cc2d97e9f22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abbc1438041e05f2cbdf4bd80022fb2a55a61f3c83638585eb90844c2defc028"
    sha256 cellar: :any_skip_relocation, ventura:        "313579ba8d6b37bdc9f47ae809eb352a2410853660d2a93ab6c61ed72ceb66eb"
    sha256 cellar: :any_skip_relocation, monterey:       "62da5fc6dfe638fd46a54fb61e6c5ab489db1aade41a9e56a48e1998d11fc6af"
    sha256 cellar: :any_skip_relocation, big_sur:        "b64342d6a382bd9b51cbd6a0917d2da3ca1d9b61235d1b09ca39c031ec0e6b86"
    sha256 cellar: :any_skip_relocation, catalina:       "8adead3ec454382591ae079bae7fe147f0e680aea905a2eee67bb32ffaeaff85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "238d808730d852c52576c62d7297d0b0f8afa3d29ae2cd983e58f26d73086dd4"
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
