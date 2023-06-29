class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.41.1.tar.gz"
  sha256 "37ceeb5f08d0586a49c46c8cc7c9872cddba6ffa2abd9182114dcdf2c41e3c74"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b98197970c9d7b945f4c08442ad5d0fa7afc6b93695feaff21506281d844a458"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b98197970c9d7b945f4c08442ad5d0fa7afc6b93695feaff21506281d844a458"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b98197970c9d7b945f4c08442ad5d0fa7afc6b93695feaff21506281d844a458"
    sha256 cellar: :any_skip_relocation, ventura:        "e753b4017abf680af91c9be83e665033050cc20a8d46babae7d42711e33be294"
    sha256 cellar: :any_skip_relocation, monterey:       "e753b4017abf680af91c9be83e665033050cc20a8d46babae7d42711e33be294"
    sha256 cellar: :any_skip_relocation, big_sur:        "e753b4017abf680af91c9be83e665033050cc20a8d46babae7d42711e33be294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cb8b41672d5e3524b56a2d98b4f7449dc0a09f1f9f6b5c806c635573cb01b38"
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
