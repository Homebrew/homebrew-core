class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "b1cd153197e3c03b20d14cb9023db484b6fe9faa86982633c8ef138cb0d75332"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c8d792e29ee58c2b810d018d4cebb26f732909e1e6fc3e40c873556d88bfd40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d1aa8bced374950c2bb317453bc91e7d8e06d8ab17de769ee87e54f3bcc6e16"
    sha256 cellar: :any_skip_relocation, monterey:       "c67457c8ae90f02d640d1c89ef238a782eeb0015378105b063e8bf6c515172df"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d3a826116652ab9440eb00b8633957c0bb79b0e3880d75a872e601516d9dbc2"
    sha256 cellar: :any_skip_relocation, catalina:       "150e70e78b0c5e764cbb2eba3ec55dc58bd2e88078ab2f5fbc9e2789f5283d64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "843b5ad531883f6d20bc9a7ab4365371c01089555bb9635ceea53fb3db3694bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -extldflags '-static'", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"jf", "completion", "bash")
    (bash_completion/"jf").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"jf", "completion", "zsh")
    (zsh_completion/"_jf").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"jf", "completion", "fish")
    (fish_completion/"jf.fish").write output
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
