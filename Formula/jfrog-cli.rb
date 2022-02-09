class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.12.1.tar.gz"
  sha256 "e7cf9aa7b31ad2958e912402ffe4b3d8b4dc8234244509f0d347947ff2ff7abd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2da27f2a8d5d2634d5b88b6cb1232d5dbaa84c9a40cf720f1ece502fdebe14b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c402a95f6f94ab0cfde8f0395a210967e34322cc9efbc98aac6b4fed786b762"
    sha256 cellar: :any_skip_relocation, monterey:       "fe7c815db088628949f655c0c10ab6acad90ee6ccb538367dd2d1a4074ee2043"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d87a8353a503fc366c4958da42e39ff53e1f3f84f5b2deed522aef654a21605"
    sha256 cellar: :any_skip_relocation, catalina:       "d310ab31c32d9df3856393d594f3b6f46ee7da1010b192140f5220a12a884660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "022eaf60e5ae8d1186c2d2e75f8d8a32b4bcabf15c167b1edd5dd5a28fd201ce"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -extldflags '-static'", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    system "go", "generate", "./completion/shells/..."
    bash_completion.install "completion/shells/bash/jfrog"
    zsh_completion.install "completion/shells/zsh/jfrog" => "_jf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "\"version\": \"#{version}\"", shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1")
    end
  end
end
