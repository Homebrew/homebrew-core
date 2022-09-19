class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.26.1.tar.gz"
  sha256 "bdcfcabce7b3cd02555a57169319ec7f3ab312e84882531f0f47b56b63d605ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbd645e6d1a5dad78bbfeb1a7b0de804ee56f32d0339f815b024858d77c92107"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5495153e9c9fd5e57b453bf59e44ff7eb262a2094216eda0d75f03f6d98160a6"
    sha256 cellar: :any_skip_relocation, monterey:       "7489ade47f43b04f793bdb87ce606383f52ef55a11a503480fa96b6d45a7d328"
    sha256 cellar: :any_skip_relocation, big_sur:        "068afd8d7c687c6265d16bad9bc1d8d01551172794c3ddd20142a418065c1cae"
    sha256 cellar: :any_skip_relocation, catalina:       "2d3a1df0c4559de9022cf5878e4c897898400987fcadf8ae81a4935a4d8e8954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e12a969d6d95d77b34f544f81fb3401dabad938120f64f29670c95e3df189735"
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
