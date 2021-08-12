class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.2.0.tar.gz"
  sha256 "ea7f7b5fb6bcb5712232325d80c1e270d4deb9452b5fa560f1a4d5a5805c72b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bb73aab63fd635c8a30718bff089ba6145583c67720946b58ed1b93e307fa4bb"
    sha256 cellar: :any_skip_relocation, big_sur:       "489cf5d9fcc7802a98b0e448f16b9c237dea63944828750038d4967b8f06065c"
    sha256 cellar: :any_skip_relocation, catalina:      "f36577f1f5dfea4dd1a5ab2230b695ae26b385ffb3d4fcf2ead3f14ee2c59e94"
    sha256 cellar: :any_skip_relocation, mojave:        "6927dde16e8ec3c4db4a65f6b9a2e802c194e1e771813ce9d108c299dbffe705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d837d70d8483bb12132edf516e42a36eed7d0d9654c7aefdb568dea8791aacb9"
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
