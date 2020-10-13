class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.39.6.tar.gz"
  sha256 "1d406c0d7de6d296fecc5a03684afad437f14d906d3da4e3c9013f1213f690f9"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "592961fdba6a0724f974a3986668fb7b37a675793c7e8abfe783388bc6cdbbf7" => :catalina
    sha256 "94d1c7e983647b20f0941a1fae586f8482d47d265d294070c2c6f81b1e3ac8e0" => :mojave
    sha256 "b5eba669580b5fa3fd9d43f0be27b55fb65c9db56a104b7d36dce78cbb60c35f" => :high_sierra
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
