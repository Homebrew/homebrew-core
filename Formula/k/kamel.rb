class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "76082e7c120d10545f8f93d87eb9cb7e6d3cd01a3eae351dd11d03a148e4b38f"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db94e27685a4506faa89786b5d917f990556f4db00fa77fe841127fb591ac6b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d54eec7b77a4a6a46287e922edf6280935e4688ebe058ff19ff104ffe730aee5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5927bae8cb43c173789fce7dd2529241b3f167b96f6630f8c4fd1c1588b29dcf"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f71ba39e83cb7f5e7bbb70de7862eefca287d298687cc464f0f08f1c6558c04"
    sha256 cellar: :any_skip_relocation, ventura:        "7158f7089b808437f4134025ebc2edb292cad09a6381b9369dd735c3fd304e6e"
    sha256 cellar: :any_skip_relocation, monterey:       "7df17aa049bfc63b05eb6f017c1cc117a749364123be8c9fe398fe1db9bbd0f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7be6df5ccf65c7f19d1b986d06fe7abb24803663800b738355c67bfb414b7ac"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/apache/camel-k/v2/pkg/util/defaults.GitCommit=#{tap.user}-#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kamel"

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

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", reset_output

    rebuild_output = shell_output("echo $(#{bin}/kamel rebuild 2>&1)")
    assert_match "Config not found", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Config not found", reset_output
  end
end
