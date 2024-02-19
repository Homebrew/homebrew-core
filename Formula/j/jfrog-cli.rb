class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.52.10.tar.gz"
  sha256 "c5072ad254852921f007e7591afaee3d89a09919ed4c8fb2e492a1c7f1215672"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "857bd4b76af7842fc2f1a1d3c76193dcd0ff76caf6b40c812704e7a10a449e2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6966a2dd64ccf9e83649d2f5c45b49b2355e2955e4b5303eeefec3af5ca571e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "273ef5d5ef935ac40528c5a24378d4c167ef26a051b4726fae0650c7f36940bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "2236961123530ab9c180668ba2675633650938f2953a014add2eddca5a05bb3c"
    sha256 cellar: :any_skip_relocation, ventura:        "80eca711863ca95ae87123e7e313bb5b447f1951ebf8e24dbcfab2dbba1cceff"
    sha256 cellar: :any_skip_relocation, monterey:       "ae8965b6bc145db79199a3d6393f52ebc8c94676dc5905a00dfcb310e6bab3a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f45ca875c949bbf658287659f9452c53fd27ea1e284e8e69048d37e22914b677"
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
