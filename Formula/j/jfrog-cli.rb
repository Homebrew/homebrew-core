class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.50.0.tar.gz"
  sha256 "5862d173e52972c8abbca3b8c005380356d1fe4f88c31f37ff2b93bca92ed2aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51f818b537a1b571cabab33431a192972de6c229eab6263130385f626df9ec7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36d00a426b5281e836e2763f8e90a9dd97e36627d8642054042646010a0dd677"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d400b38a887c5334b383a80043b47a5b24bf082527eb2d55dd94673c11e3d645"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b7cb5a2452c4519a3db566659f24c7000af20bb54d13d04ef4924707ad1ba66"
    sha256 cellar: :any_skip_relocation, ventura:        "7cd93e3a343137737ea6746685c279ef3b92dd6a948ad56e1d9f4b7f8f575e23"
    sha256 cellar: :any_skip_relocation, monterey:       "31426d3356c79800ec4a9907e8c15cd92c9667da4a5dd2f63dc1c36148ccbc06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c43ae9e0fd16732fe11f84ecb9e049ef14e8b0f5a1dc5d08cebb05bfed8fff49"
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
