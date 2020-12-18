class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.42.2.tar.gz"
  sha256 "f2c6efbe8f91f8dd5a5cff566a3143045ca421854b7aa5f1f81689924c2528e1"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "3287a1b98482952e6bef495da3a27c24a4ffbbb0de99a8a27bc336951776d777" => :big_sur
    sha256 "92f59c208adc24ac3fd8e686cca28912494d60d8f7521bae2a308c1d27e798b4" => :catalina
    sha256 "18d4d6d92818ad3ec73dbd6e759a6988a530230035a518300e1650ac7d674b35" => :mojave
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
