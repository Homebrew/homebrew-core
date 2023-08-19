class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.45.0.tar.gz"
  sha256 "80e7e9257f235c8bfb5c3483090d703efe1c5ac3d34344ed33f0b1698f627fe7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4561e1a25c5b372cb703689a029950c469be35640d28789a7704cc58971cdf48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4561e1a25c5b372cb703689a029950c469be35640d28789a7704cc58971cdf48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4561e1a25c5b372cb703689a029950c469be35640d28789a7704cc58971cdf48"
    sha256 cellar: :any_skip_relocation, ventura:        "5df5902c3bdfc9750257a98d740f1df969386be68af8f7ef29c5c4f8328015f2"
    sha256 cellar: :any_skip_relocation, monterey:       "5df5902c3bdfc9750257a98d740f1df969386be68af8f7ef29c5c4f8328015f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "5df5902c3bdfc9750257a98d740f1df969386be68af8f7ef29c5c4f8328015f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d9cd641f2a00ad57689f10fa88f58ed2e5b01577a3efbbb4b4b326ddd48e19b"
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
