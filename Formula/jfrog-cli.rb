class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/1.37.1.tar.gz"
  sha256 "8f40d56a20a26ad5f59e1b355c22b726ffeacc2dfceaa2b808e7258ff68e41df"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfabac91df7c7ef240471c9abbbf64fdbb91a39ca7076fdbf0db5f39a242d08f" => :catalina
    sha256 "075d434d00e81a8baa9e531757f37ab37923ab0173e32baab3050ed2f8eebca2" => :mojave
    sha256 "c266c9d63c404e8fc550442eb24063a26d568aba27c8e58a1ac1df3c48a12a78" => :high_sierra
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
