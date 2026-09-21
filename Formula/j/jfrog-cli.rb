class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.124.0.tar.gz"
  sha256 "05a232abe46627a40df4d509e8ab7da1d8532bd5f50317b9189ae26fa572e23b"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d4390c4930c6e73fee29f27d01706596bdc1caf1bb0d70c9037935562f8d7dda"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d4390c4930c6e73fee29f27d01706596bdc1caf1bb0d70c9037935562f8d7dda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d4390c4930c6e73fee29f27d01706596bdc1caf1bb0d70c9037935562f8d7dda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "d4390c4930c6e73fee29f27d01706596bdc1caf1bb0d70c9037935562f8d7dda"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0e34643c80d5083744d9af6cf5a55b84efb80db9ac319a8f7394a53ac4db55f8"
    sha256 cellar: :any,                 x86_64_linux:      "50f73b9d37ecc40cd31a705b45c9fbadbc0e45b1814b11fe53e3799dae5e9ae8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
