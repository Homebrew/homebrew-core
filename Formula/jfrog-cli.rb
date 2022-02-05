class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.12.0.tar.gz"
  sha256 "4a524dd36165ffe992b80cb81c9a80ab027158319fba1b828e2a0e3ea53a77d8"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b51c6aeac710e8dc3e5e929a359f660bb1a30f409bd69cc1c77abc7cd234ba3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4a838bae115be7911bcfaf46bb9e5eb989b9f977f7cdd0f27b933d65a5e18bd"
    sha256 cellar: :any_skip_relocation, monterey:       "159b9cf5765640c343ce2f5cad4904a3fc1e37976ddda3d67730bb196621f049"
    sha256 cellar: :any_skip_relocation, big_sur:        "583e1aed2e1197b3f583df9d649cbc1f69a5b6ed0f3f35ace78a6e2083d254ea"
    sha256 cellar: :any_skip_relocation, catalina:       "5270e18c2f07eef87b270c72b75413e9dcc3d103874efcb152c280ff5482cfd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a496f25a5d9c653b6c1fe271296203b1061514de66967740f3f08c71c298720"
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
