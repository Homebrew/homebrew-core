class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.54.0.tar.gz"
  sha256 "1d6758df3c4fe13247e9f58512328960ee2668e4be45a46ede3a0a2b3ad8f803"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d7c210f3277a176634fcf18aaf6ea43109e2fa5da57b2d4150bdd28c4b93a3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d5881bc888b4a86fbdae821d8714234595b3d6cd78f23155638d7bed12dccb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad1d969fafc1fc7545216762e28bc7d1589e410eeab3c3adf2fe3388247259f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "e862471b498509447298a810b42a5c0951c64b583f3a32c15de124540c0114e7"
    sha256 cellar: :any_skip_relocation, ventura:        "1b13fd8b9956696006eb4ceb6a97e3f3c74dee2d4f539927681fd2fd50ec79cd"
    sha256 cellar: :any_skip_relocation, monterey:       "682773dd94d7be4fa3882604c38914af388b05a321f60676a5517e890fbcf685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f772da33c13ec72df109fc2f116f5f8ffd8659095be158f5cd40a197fe4ce35c"
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
