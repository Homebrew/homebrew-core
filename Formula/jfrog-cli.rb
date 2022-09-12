class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.25.4.tar.gz"
  sha256 "fc1aee2eb52a4312e309867441bbee05534269b62202b2a7141c826c68d18c0f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fb4c098bf2186bda37dd8a855029a6c2cd7c5a7dd203c69230d4cb16bcd022b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfd1d915b9a66ed4e5121553125535eea34795e0cd91bdea29ab66594c758ab9"
    sha256 cellar: :any_skip_relocation, monterey:       "4789ba7d431d872198861660c356af5484456749fb089b35e2f81b740a3fc433"
    sha256 cellar: :any_skip_relocation, big_sur:        "1233b05e072e0dd779fc15d2e0562f17fbfd32374965d022404a00f1c791b1ea"
    sha256 cellar: :any_skip_relocation, catalina:       "36bf170ca8426ce1b44a527c095200d68f70b4e59ddbaea74df4ac504a1ccc34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7e255e0113be1f0ebc325a0b58788c8a72e0750048e7f6179f0189be4211eb4"
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
