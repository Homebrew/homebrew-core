class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.47.2.tar.gz"
  sha256 "a1bf13dca8ab1486dc0f87f940f900a5f0199da47370cd3cd4924270aad74857"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f121ce9155242a15ba146ed2b19d4037e28bd7b8db7d68e574e1423bd17904b3"
    sha256 cellar: :any_skip_relocation, big_sur:       "5ffae742ac51fa3b4bc31f4a3676cb0bcb5b773bc570b70fe3bfa5c419d71bc4"
    sha256 cellar: :any_skip_relocation, catalina:      "518dbade55da3b64954a242e1547698a3104887f671de1a265b101655b6f0c90"
    sha256 cellar: :any_skip_relocation, mojave:        "e59437cf1344400ed6f16124bf1aec71b908b159f1f3767d6eac31ccb9765b68"
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
