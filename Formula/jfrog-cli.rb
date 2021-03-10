class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.45.1.tar.gz"
  sha256 "f2869aaecc096a6d3e65a7a8dce17876143d0bb744be4d0ce9749e6f1d7fdfae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "00ea5f818217c2000763c1f3e5702420f2fb14638f7050bae0ae15411979d127"
    sha256 cellar: :any_skip_relocation, big_sur:       "44e8d9a70d0009870f15906909899ac6af0b9434210cca9b7fbbe872ed6bcd20"
    sha256 cellar: :any_skip_relocation, catalina:      "eafbf6c9bc913f2b7bd7041b76c80c38294f6aa38132010a7fdead65e82932c8"
    sha256 cellar: :any_skip_relocation, mojave:        "b9978934160e1d1fb6daa712b90b1728988ca816998bcde93ad59b55953879ce"
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
