class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "220e779be71e0e2c9e622346975abc5a70f7dd6b6c60daf3515bbcac46b92383"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94866f102414ebf2847d884ea8413849d8542144015258123963a61e4d7e71d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec606d94e76dd467836a1e5dcb9e6f3b8a98459f5c2748181c8553e311dda518"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0be95ba7c330d904c297f623d855798cb59e7478e22838ee5da025f2d672100c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad402478408c92bf84410dbef0df8f0bacf4737a236499f08da453e1ddb761f6"
    sha256 cellar: :any_skip_relocation, ventura:       "395351fabedb60717cc1e452071cf013c9d7cf7b3d86070d7f66b8566f2b21d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b76d52aec8f5c5d199f96a11cc65a80448064f8904b19537454d3d1d68c8e315"
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
    assert_match "Error: cannot get command client: invalid configuration", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", reset_output
  end
end
