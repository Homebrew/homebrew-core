class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.48.0.tar.gz"
  sha256 "5986981b92fa6efee633fd73723428a23d111d8d9f739cff695183405b75fd6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1aa3ff6073b72f3c0a16a7cbdf2d37a02f19436a33265bfdaf63aebd3e78b66a"
    sha256 cellar: :any_skip_relocation, big_sur:       "b1989adc27d075c8597a749b813f2af0855dc1cd72ec768f9dfd487e658c66c5"
    sha256 cellar: :any_skip_relocation, catalina:      "96dc1a35a1cdc008236e46a48eebd528fc0c9887e4bc1c8f98157ed21bd2a67b"
    sha256 cellar: :any_skip_relocation, mojave:        "5b8cd096233a4bbca287ed3e6a5439f08c8197d5f53aebdfce7dea3c58fa7ccd"
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
