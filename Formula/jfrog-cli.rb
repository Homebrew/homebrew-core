class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.38.1.tar.gz"
  sha256 "c3ae294009908adc60fb31a321d73fc288a00674c7d70c375f15803096b2b12c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8325af4cf83e40ad02fe5bb401cc7ef55e8ab1c2c4f2d87c4c62663aa39c543"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8325af4cf83e40ad02fe5bb401cc7ef55e8ab1c2c4f2d87c4c62663aa39c543"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8325af4cf83e40ad02fe5bb401cc7ef55e8ab1c2c4f2d87c4c62663aa39c543"
    sha256 cellar: :any_skip_relocation, ventura:        "f33eb77c7899a27e97267ebc172ab97024b3fa07b544f78a704d7576431a0f69"
    sha256 cellar: :any_skip_relocation, monterey:       "f33eb77c7899a27e97267ebc172ab97024b3fa07b544f78a704d7576431a0f69"
    sha256 cellar: :any_skip_relocation, big_sur:        "f33eb77c7899a27e97267ebc172ab97024b3fa07b544f78a704d7576431a0f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b470beedbbfd15865e69b1c643cb82dfe82dd9ac125731a75f7e76889dadb284"
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
