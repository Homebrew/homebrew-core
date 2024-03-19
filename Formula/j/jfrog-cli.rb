class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.54.0.tar.gz"
  sha256 "1d6758df3c4fe13247e9f58512328960ee2668e4be45a46ede3a0a2b3ad8f803"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "467cdd386753846e4939d8c9e9b0ddfb518e80800e6cfe750788b099ae45e8b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef482477e60af882f24f641b6ba6e7512ae09f1dcb2e484fa0a845748714bc32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5facf30a0fe7c5d5d67a19bf94bf5890dc521f2abfe77c68f326edb1c542f53"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ff6d3f91df1484dc79182a83fea01fb232302084efe1713c53510a7113362df"
    sha256 cellar: :any_skip_relocation, ventura:        "828255e87131ed3a634cab9aa99c72954616684e490594aeec6225d3457cdf16"
    sha256 cellar: :any_skip_relocation, monterey:       "5f9c1560b1719006bde3e238fe82ee093bd73378bd44788f687e0774f7b92c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "764041587b67b0e324713cedb3554ad5319d9907e7df01f0b37e4e9c50b2f1d2"
  end

  depends_on "go" => :build

  # upstream patch PR to support go1.22 build, https://github.com/jfrog/jfrog-cli/pull/2447
  patch do
    url "https://github.com/jfrog/jfrog-cli/commit/9cba3d265b798f5a7768af2317a12de9c01ab401.patch?full_index=1"
    sha256 "2c3fb451956d5de0382371612456cfad5b907ac40e2240507a5050ea4df4c797"
  end

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
