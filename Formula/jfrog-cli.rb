class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.29.1.tar.gz"
  sha256 "d7ba7626ccef1b4a0e07b99c98d329a0200a74a3005210be6511fab189e4bfb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b06d161aa7f4333b83dbc9b8410daad8d69ef65deae8da62f628c86ee106db2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c99b771ddbd83af6495380f4ee3e087a165d54629b604bd02f34ae072fd3f974"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6255ee64cdcd045f6438863ab445d1f10d018ca869d820d502d302d449f1a52"
    sha256 cellar: :any_skip_relocation, monterey:       "1faf152ea196055f8b9fb4c518cd5d49ac2884462eaf59a30bdf965db9891c4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e4e6cce64f2180d47011489b5b89cf427a24cd3d981584b06b49d959e6a0a23"
    sha256 cellar: :any_skip_relocation, catalina:       "8a205877c06675cd9c8e979b8a9b57342997f0cd29720b8de15cbdf571a94809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3692dd5a83835777db8a773371eb9973819a21c028f853cd7c1c2b36560f568e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -extldflags '-static'", output: bin/"jf")
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
