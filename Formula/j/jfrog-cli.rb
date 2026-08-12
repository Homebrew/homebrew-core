class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.120.0.tar.gz"
  sha256 "d05398978d03cdd9c2526218fc5373c9041b4e13b504e55a0f25b3ccd5aec364"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97f3d03e054c5c2aeccc03ab0ec5e2c8057e120fe4a9d3292215da3f3ac6e8d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97f3d03e054c5c2aeccc03ab0ec5e2c8057e120fe4a9d3292215da3f3ac6e8d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97f3d03e054c5c2aeccc03ab0ec5e2c8057e120fe4a9d3292215da3f3ac6e8d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c7fb219f7e1e333040b8bd56b44498fc5dbb67b6ffec62cb072ea0fa9429fc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c5d4ff657e91878689d228d2098592b54c5e30ea905c105335720101772a888"
    sha256 cellar: :any,                 x86_64_linux:  "40dd097f30957ab6c39bf4d4c0664bba6a8eeb74ad2c3b0e5a7b8ab8f59acc0b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion")
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
