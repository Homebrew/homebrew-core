class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.39.6.tar.gz"
  sha256 "1d406c0d7de6d296fecc5a03684afad437f14d906d3da4e3c9013f1213f690f9"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "37c3af9087bb8d57a53720f23afbb2cae13ad452ab57f9b19e9edc6f34571cc1" => :catalina
    sha256 "f36122bbc333b05da197a534ad4c38a2fc9d98823c736b928202aabe73a37a05" => :mojave
    sha256 "dcde45715eb7c501dbbfd5fcca3a9d343a972a859a68cf1c033561207da50312" => :high_sierra
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
