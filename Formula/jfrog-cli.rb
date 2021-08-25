class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.2.1.tar.gz"
  sha256 "5e1b30cf347def2ba5338daaa99504eb6c0006af973dab5db8cde87a3af29991"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a16f5052d6d13eff3d0883aae3917f9d5c80225aaa054fe80867f9979491f0bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "23bfe559ee9ef28c180c11fa2ab2c167d387c70e9ddb2a833d779096098f7b71"
    sha256 cellar: :any_skip_relocation, catalina:      "8f2dd53b2c6163adcff3908aa5d5b1732d84535f27661b7d80d7b84fccbb72f1"
    sha256 cellar: :any_skip_relocation, mojave:        "8477f98a518ac8b2fb0a9c821c531b08c4861a8518485736c41715072fdbb7fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd7f20c51a8119e9af5b11366b1ad4af31e93abf8e4ebcda90e34c9ee3183f01"
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
