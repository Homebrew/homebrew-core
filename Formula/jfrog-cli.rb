class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.47.2.tar.gz"
  sha256 "a1bf13dca8ab1486dc0f87f940f900a5f0199da47370cd3cd4924270aad74857"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "50ce24ab3161a1be8c9dbd1fb81ed25eb3f3f52b842afd0eeaef52cc8d62c982"
    sha256 cellar: :any_skip_relocation, big_sur:       "47c51683ffb76d3485bedf521a2afd72b906ceced331725fe991d408b46dd16e"
    sha256 cellar: :any_skip_relocation, catalina:      "9ce92b9c0425c5c444d6fb800475c39635ce831253c8bea68507e3d457fe77ea"
    sha256 cellar: :any_skip_relocation, mojave:        "50b70ee678b3275024fc854e7317676d4b942885fd34de5ce686177c0c664878"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -extldflags '-static'", "-trimpath", "-o", bin/"jfrog"
    prefix.install_metafiles
    system "go", "generate", "./completion/shells/..."
    bash_completion.install "completion/shells/bash/jfrog"
    zsh_completion.install "completion/shells/zsh/jfrog" => "_jfrog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
