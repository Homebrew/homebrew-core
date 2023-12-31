class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.52.8.tar.gz"
  sha256 "1d38f34d487751f4a5d61d2dbe16ccdedbec9d111bd1fbe4b1229cf86328914c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd5de7b399b1153ccbf91f9be1dae298a6c494ede14d5603509c49999ebeb8ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0f9ad4d5710ec084797a0a7fb7f6566fcd9f9ff9e787913567c38884b217098"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ff43f6024a7b5e363db44c40d1c1214abe5322282163049a19964d4ba1d8aa1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3455ae075a1ecd9b4bbec65ba73007252ceaa204d48cc385c72d57d73054969f"
    sha256 cellar: :any_skip_relocation, ventura:        "1f4a68bd2dcd903541fa0a170b45cc78c5b3d1f91b91dc29082a79d6146e1e55"
    sha256 cellar: :any_skip_relocation, monterey:       "a25784d1284b7c524ad29155ab223d21f2ca4a91e8d20957ebaf22ef5ba80892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ca3507dfb8fdc74d00b5859befbb6e3a9e8555daea9d3c2f622e6e4f18ae505"
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
