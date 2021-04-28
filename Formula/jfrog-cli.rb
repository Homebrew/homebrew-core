class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.47.0.tar.gz"
  sha256 "508b12a12275ec119916294a08379490e671caa4726898350199d8636ef07788"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "815ed11c83f72f6244e853b1ecdd7686f22c77f2b4577dd10efc84723990a3ef"
    sha256 cellar: :any_skip_relocation, big_sur:       "68e65a1f719306d132871e65066c739b609fdfe45af106c7856ebcd56b16c4e4"
    sha256 cellar: :any_skip_relocation, catalina:      "dd5a65d8d0b44a630ec19b8199903d8877dce0699e3032df5bd7a321b0e64c99"
    sha256 cellar: :any_skip_relocation, mojave:        "6ad2e8e730f309601773c5723d1b86ebad4aee90db3e1650549fbe2ed4e28348"
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
