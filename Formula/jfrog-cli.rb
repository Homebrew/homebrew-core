class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.27.2.tar.gz"
  sha256 "408013e9bc87eddb1f546372be7d418407bd5ae8132bd565cc3b7fd69a70af56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab70afe98498209ea2652a4b04d76712e7856012885bc80a1a5b13d38ee104d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b9b9257c8064f7b753bfc56b6cd667e6b3a5958e7550fb144d2f1f2a05d216f"
    sha256 cellar: :any_skip_relocation, monterey:       "3a0cce376d9f4226d74c29503a1d01262e8e9e330e322cba4679497a3e8727e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee5461b30df353a6f9759003b3c6ad6e8595d36fb802e5015f4858252ec19f82"
    sha256 cellar: :any_skip_relocation, catalina:       "a529117ac828d9714d0fa031cccc476117a8236e5e77ecb89aa41ddd923a921c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c3ecdfd4c4b930345e536f8299cc03ccba6ad0aa38a2e90f4b3144e1130635f"
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
