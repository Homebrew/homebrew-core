class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.29.0.tar.gz"
  sha256 "df7d15147009b43021717e11df365f7d9c4f10af3033119c5433ee6602a922fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "217e81854070295462a320e7419b2fb3dd28b9484b2b1f4f260f03d6d8b2fe3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eafbb335d103cd229547d3d99cd22f9e9a19e1c519c91175adc39650614bb0f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2bcb316993c591da5b38cb1f4d2926dae0fa2a4f0ac24b0345eb01da753a004"
    sha256 cellar: :any_skip_relocation, monterey:       "f5d9b8b76f2cbf672d80aaa33e9c5c67c019c39e387bf13171ac5e3e03ed73f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "800e79fdbbad61c4e8c1f0771c27e69a01af3cf91f7a6d819c125097dd853eb1"
    sha256 cellar: :any_skip_relocation, catalina:       "f0ec11520d1b4e02defa4e5fb69f94881a1b44252c4fabbb92bc5aa0f82174a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0314bad51641c2a5af05712978c3f2f26ce32df848baad0f6b16bd7f4149791b"
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
