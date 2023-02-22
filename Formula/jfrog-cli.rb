class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.34.3.tar.gz"
  sha256 "87c10cbadac8d5203dcd5cfd29d78952416b7ca898527b32b787f811ae41b1ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f169c04f6328248619b5775957712a1a6c970c3c69a81988de67bb83d212f9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "817f6d95962a099627b96302f1c95c5c5053ae8ce093c5217ef6439700d25265"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92cfa89a68f08e8ef447bd0be763d667017032211373d1b89c0d27fc587d0f8c"
    sha256 cellar: :any_skip_relocation, ventura:        "75a5bab054dc754dc50f687583a32af4d4767e28d5538fbd16bf857359f174d8"
    sha256 cellar: :any_skip_relocation, monterey:       "94ced211c976b558f4489993da8e08ccacd3e9491876d9f1f800ca5bafb8e28e"
    sha256 cellar: :any_skip_relocation, big_sur:        "970c93a0831632c84b5c40bbde2bcb4f5790420567ef995736913e29ecc3fe44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b7c87bc55a0a8aa6ea4ceacb38a8cc015a528ecb62aa3079e6523100127fa9a"
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
