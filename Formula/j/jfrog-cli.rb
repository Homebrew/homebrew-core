class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.80.0.tar.gz"
  sha256 "59c2c5b2d6cda0e06069c5249baa05431507dadc694d173e764653455efdae5a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2228807789c5ae84e5d3541b63504a281b985fa223789b9e9b9f95aa98b584b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2228807789c5ae84e5d3541b63504a281b985fa223789b9e9b9f95aa98b584b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2228807789c5ae84e5d3541b63504a281b985fa223789b9e9b9f95aa98b584b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fea5a389a144bbbdc47a4c83b54d8bd235abe1f2eba22398264509ed0ed191d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f2ac9eb39a64bb878e83b24228f416536f37697df20f6465f81cd72495ee236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd679c609f662bc2eece78ad46267011ce384adb1cb4aab9f617cfc62d0525f4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
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
