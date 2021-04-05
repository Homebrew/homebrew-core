class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.46.1.tar.gz"
  sha256 "e641fd1df41319be03f70d45a959b3526322338e15917d95cae4abc4094fe526"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "02fbd6559e2f5815b4fd08a1aab08b3bb4728b080edca5a0dac52fbf37343742"
    sha256 cellar: :any_skip_relocation, big_sur:       "62e034fd434841e46a89c2f866c47482719b1170b46a427475e87183436ac8e1"
    sha256 cellar: :any_skip_relocation, catalina:      "c9bbeb76fce4e91d61a68da62d5350bd4aa099fa82bebf0a94ee2102fcb61514"
    sha256 cellar: :any_skip_relocation, mojave:        "b064665c14e35f49699086011406fe9f931dfe14b5e055808763c41a1179ef6f"
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
