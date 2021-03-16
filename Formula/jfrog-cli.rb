class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.45.1.tar.gz"
  sha256 "f2869aaecc096a6d3e65a7a8dce17876143d0bb744be4d0ce9749e6f1d7fdfae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e6b6559a3e9ba7d3381a73862c9c175ecdd66c2430cfc3a1eedd574563b523e7"
    sha256 cellar: :any_skip_relocation, big_sur:       "723f19a690ce555e0b0880592d4e263780f34d4a75fc349844ddf4b69ccca006"
    sha256 cellar: :any_skip_relocation, catalina:      "98b6e8d5a21a42f2e523819471f8f8811b13af9c007575375ef209248d0a4a46"
    sha256 cellar: :any_skip_relocation, mojave:        "ac313fa7e83878680efac28c0feb464f2cb5020ae54417a1051f1822008628b3"
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
