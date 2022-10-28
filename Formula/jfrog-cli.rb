class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.28.2.tar.gz"
  sha256 "3de835fbf168f22bb9842c14ee5c4e43a20f88267bb4e2e3c617dff1f9f7b74f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fbfe0f2d955ec87ac6153c35efd69131f92a25f3f2afaecf4ec924fb9ccdf71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5fd4aa52537cdc66ad7ec1eedc1fb973388d7900f82caffba2182880415545a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ceadc1e660516ccd61d2bdc1576f8308361a0b898ebffda95a663a05f790a42"
    sha256 cellar: :any_skip_relocation, monterey:       "5573dec7fd1e06b01729983f9d2a3d644cd94053b333aa324cbd75aac8044549"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f7d01df024b2133094f2d54b5a423e6f4e793ea0232a1bac1a24551587eb651"
    sha256 cellar: :any_skip_relocation, catalina:       "dfdc2a1310e4deaea98298d88540c46e52ff7365e70100b8cba21c098ff5b496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cfc52807224110ca031d1fc7c8830db3ed8c125f7216e8bb1181a3080d7e059"
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
