class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.71.0.tar.gz"
  sha256 "6f2fdfd26c3546644f2654fc4ee94e3d5aa32e388311fb82a3af363a27f1a25b"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6fde70251bc984a167a4e54a2ece8cc4817ef0f650a0319e0ed5dbdddfa5022"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6fde70251bc984a167a4e54a2ece8cc4817ef0f650a0319e0ed5dbdddfa5022"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6fde70251bc984a167a4e54a2ece8cc4817ef0f650a0319e0ed5dbdddfa5022"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec233824dfe1e5d6886b7e7452f6731dceb1da1ed2c3193cd4029a86692bba06"
    sha256 cellar: :any_skip_relocation, ventura:       "ec233824dfe1e5d6886b7e7452f6731dceb1da1ed2c3193cd4029a86692bba06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d29ddcf8cf74704688564c1fad9b78c48cf75040a81bb82d800c7514cd6f97b"
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
