class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.45.0.tar.gz"
  sha256 "72b58f4b8372b062f39167b10f6ea140ed1a29dce57ce76c9843d0b3a019e569"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "189a8eb21ca5cb325f1749bbaa5f639bbb018f6b3e4d508468edc5df4b364ac9"
    sha256 cellar: :any_skip_relocation, big_sur:       "b687983a93111f97106ff72cdfc6e9e4e54bc3810c1e81c3b80e292bd1e5c195"
    sha256 cellar: :any_skip_relocation, catalina:      "9037173dea0bbb6700b8729e071e511e5e9b2e4b294dcdc9c2e2ad600c857020"
    sha256 cellar: :any_skip_relocation, mojave:        "12c87df5a2a0e87f616fc522b4b47b8f43fd3d78ae477d698bb33607f0642d1a"
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
