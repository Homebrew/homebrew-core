class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.47.1.tar.gz"
  sha256 "6c252d46b86449144aa39733ef77007cc3b5fa5372f7b7a6fbd6427b0d00e529"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a6908fd19539eb047af1b37c92a3b5929200dcc9ce60f35fb5ea8960f38074e8"
    sha256 cellar: :any_skip_relocation, big_sur:       "c5b64391aa80365dd8f0e1391d5ee3662f3350c5505d7c9d21b8f043e7f80690"
    sha256 cellar: :any_skip_relocation, catalina:      "f3f345ea6bef9958d6124a16fbbade8dcc08eaa25560736a9ab364c8a7c34013"
    sha256 cellar: :any_skip_relocation, mojave:        "2300a47217317b451baf7b7a7beeb3affeaf5e89b46f3490cbfac3cbf0058797"
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
