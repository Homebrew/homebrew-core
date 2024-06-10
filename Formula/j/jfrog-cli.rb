class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.57.1.tar.gz"
  sha256 "48d4e5d5b8718a68d20e96e3330d54953e448eda83aa5e28ed71eca205d27c22"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "584612f04b662cb219b0ff44a7f28ca66859bcafb9ffbc72b2bf4ef662b08261"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c3d620689ecac07e2cf8d735795b47254683821dfb2754f90f6215025b26311"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "182b5de61855d93c633839e492b1244be495096220cce3531f2c73e3e6f494b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdd6e0824a63bc20087f21fbe96ed6edbdbf6dda6b59ee9cb6653649ec2516f3"
    sha256 cellar: :any_skip_relocation, ventura:        "19a36ba2370b2f6c974335fef4372b25cf4585f5afb928b4793de934005ba026"
    sha256 cellar: :any_skip_relocation, monterey:       "bf0bff4a0380891e3fa754fa95ea525849e1d9a5d2a7e1916690dfc2b7a16880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8f72bb81ae407c5a7ed7a6d945be59f2ac130012a2259a3a865993e9caf72ff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end
