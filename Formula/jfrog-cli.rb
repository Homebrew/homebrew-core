class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.46.2.tar.gz"
  sha256 "ee25a4e5c66e75ead680fa2b7057073fe6d83c6f5290e8fedac5ee5f7eb59f87"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1d0f7ae6f29bce639467fa1c12b7e7552e1f9894c710913678b6345f03d6cf86"
    sha256 cellar: :any_skip_relocation, big_sur:       "c129dd07afc5278c627f5cf50b5052c676ca2dda45474f28e6d24968f6c857bc"
    sha256 cellar: :any_skip_relocation, catalina:      "ce7e71ebecceb7069e2970d04e16f88eea3440ab29230c4f360a5bc24fea1ffe"
    sha256 cellar: :any_skip_relocation, mojave:        "6eda98842eda1cd5564b78d4ed0042fe45ad06c9975c6dbe0e3bfba665f45ae5"
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
