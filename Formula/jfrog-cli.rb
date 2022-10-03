class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.27.1.tar.gz"
  sha256 "ecf54de4bcb1ee222671a572329fa7c93534622d44b0149730a575478d1a7556"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9194485937d4e16c650d4f214d896f4cf7c47a2f926216c06887e7ea62d5b05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb437efe9b2029e47ffa3e49f1afe6502f44fdd99b0003003b48c77a621daaa5"
    sha256 cellar: :any_skip_relocation, monterey:       "bf1b0bb79d451393d4dc8159ae056294bc161d7f90203f481ea651eded137576"
    sha256 cellar: :any_skip_relocation, big_sur:        "e21a740f379abe7f1c92c8af06f39660503949cadc2f11b1622f2cbe7e27731a"
    sha256 cellar: :any_skip_relocation, catalina:       "1eac18a801da00ce454277acc8774d0c8b2e4cc8654be1c1662cdfc743a26569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07a5a17404abfc8a91b535c631854f36761092c18275fa19a3d299eb136666bf"
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
