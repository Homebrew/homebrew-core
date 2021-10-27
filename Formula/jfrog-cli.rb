class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.5.0.tar.gz"
  sha256 "370f69508bb14c0c66fe4d99948a39daf6d88d4ff0e690e320d5d6ab99e4c735"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2885fbb1b5c3a4c1daf86f1c32aed03cf62cfb0376148c9245862a3db68d20e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "342ad46e482e95c4b9335c0de8f4097a18c5c4757c23dd1542678c9a61b44a33"
    sha256 cellar: :any_skip_relocation, monterey:       "99d8b968c6f1681278bf4b3836723d5f9f518d7cb92875ebaaca39209af64db1"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf00236ba19abe9614c3e69870b7450fa8b09e7ed6595b42d54cbb5ce5f77229"
    sha256 cellar: :any_skip_relocation, catalina:       "223adb77126c1d39ee7ae37ca650bc6cbae2946c6c44b1a5a08a75569ca677d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5167b04cedb616915eff0e229b3942465d97425868f189e76f6aee5fd6ccac32"
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
