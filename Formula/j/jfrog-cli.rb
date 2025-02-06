class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.73.2.tar.gz"
  sha256 "c0d9a8501fa9160c1610afc6dfc427518398eadcf14369380aea6050a027140f"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24d00e86915bbeb2cd1b81ca21a8fde8152cfff0510fa711aee9cd5abeb488e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24d00e86915bbeb2cd1b81ca21a8fde8152cfff0510fa711aee9cd5abeb488e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24d00e86915bbeb2cd1b81ca21a8fde8152cfff0510fa711aee9cd5abeb488e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c8d680ab184c562afe24b1a95a854de823a7f073d46e5aceb5517fb90828865"
    sha256 cellar: :any_skip_relocation, ventura:       "5c8d680ab184c562afe24b1a95a854de823a7f073d46e5aceb5517fb90828865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afdf83c6b37cfd318848aa741d9bbec648d31bda825fa64fb491927fc7f15c26"
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
