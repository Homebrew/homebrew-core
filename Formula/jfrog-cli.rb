class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "ccd9457e097e187bfd083716cd7e071bb75c22a24d402839342c330a2e2cd72c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "569d13143d56b391d02b82475244e999487bda2cbc73dc174ad8cd16a13a25d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e567dba35f464edf193e177e9d0c583c7125401c4900192750ab7c0724e87404"
    sha256 cellar: :any_skip_relocation, monterey:       "a82ce459f5628b960cf0e6a52ffc4b6374f998a97f2a2af4f6366f6efcb7d2a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad572a5a25b3745ffe115a961ce2f8232ddb994bc14e1502c7f6e1ffadff47d8"
    sha256 cellar: :any_skip_relocation, catalina:       "d9810851d4443f4c4a622fc4356dfbd816621c2b2c26bf4c0c2502a7ed649b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a13f4171d4895257d90a66ef4f0beb18a92837ba129961cc57f6d2e9418ba81e"
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
