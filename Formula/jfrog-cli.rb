class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.31.0.tar.gz"
  sha256 "d122d7e07c2b41bc7f405b4640d927ae8a95e8e95a2923c7617ed2c7e3937de0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35240f69f21aad7f5b1245e2a6da60ce8bfb2c2d94527917c16653e31b777786"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eef271e6f6a62ea79701577985bd80742f4305e0e3b70930051389664abf0479"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f398b186cf3a6ba4228acda4201eba5295505fb2cde74e70c0857abda072b2f9"
    sha256 cellar: :any_skip_relocation, ventura:        "12309e08eee064ca99b5f4257cdd1c9179cf7f719d1787723ca5e462c5dbe0bc"
    sha256 cellar: :any_skip_relocation, monterey:       "f3c59cd9997bca0a8da08ace18e4e1c3200b88bae9d056f4f8d8954b62a910ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "012dec2dfbaf54dcead2ce7aaaaddc1fb0541cf75b2c9586c12239222c3fd644"
    sha256 cellar: :any_skip_relocation, catalina:       "1be086039baebc25f82ec163a3e615dcce47138961be67d75c5964cf6cae2992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83ddc98dacad6a1c2b7ad8fc0d08300f8f799e8b3d0164ce25bf4ed81f6a8dc9"
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
