class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.56.0.tar.gz"
  sha256 "ba6eeefc0909c2ef01577421aaabd9e4d911777f6c5555ad712248a41bb140c2"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c09f7d67fdad5aa6fd41a491652de81bc33a6348a635fe55622817c9556360d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa56e034f4caf1bc3e1cd0be081ebd9e45d3415329f1387ebc05313392a75ebe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c12e28667071895b7dea6245c38fd89a263f96ac08afac351ba751f24defa2fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "34e6e226729aea20b836301412c7343adf6841f338f55c2a9e2a34fde464ede1"
    sha256 cellar: :any_skip_relocation, ventura:        "a33d07e3359090d580d95bcae61f7ba4c1c820ed515a67b69310035c4aff2967"
    sha256 cellar: :any_skip_relocation, monterey:       "8c8664c5e33fe26330a841715ba8de017440803d33631bd4ed90fa54b435f528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8db2d60995f14aba767c13bad6f8ce7905f89572711d808f08e927ff9885b01c"
  end

  depends_on "go" => :build

  # upstream patch PR to support go1.22 build, https://github.com/jfrog/jfrog-cli/pull/2447
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/12356db68700fa62668e9054fdf9eb5a1b99a05f/jfrog-cli/jfrog-cli-2.56.0-go-mod.patch"
    sha256 "b04c90f23857e8105f14a9f96da472985d1ff00da6ff9da0a5b74df08e31f5f9"
  end

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
