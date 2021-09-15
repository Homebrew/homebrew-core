class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.3.0.tar.gz"
  sha256 "8319d4ec5d70958f3582d06dfd0dc12093d83b7a0e5bc7861526ddb289611d52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "528b7b3ee0e3a2dfc367c51221a0572b7946c3c7d31e88397021755a65f75405"
    sha256 cellar: :any_skip_relocation, big_sur:       "1e1418d073fd080cf14a6793d78305c1d7bf65c735bf7504e7f12e4ddf882b2e"
    sha256 cellar: :any_skip_relocation, catalina:      "9fce8dac118205801e673b0f2bf32f83b742242dbbc05de01546d6c6c161312e"
    sha256 cellar: :any_skip_relocation, mojave:        "825338fcd0a8954d7c1bb92cb07bbf2b2bb2f0cd16abacf14f7601ad37bad7e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a618ff0b129fea86f720a7b6e9f44cede07126dfeb270e00fad8e9602dbf913"
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
