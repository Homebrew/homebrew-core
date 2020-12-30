class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.43.0.tar.gz"
  sha256 "fd2a863b000cd0193b51388bc0e7b16f27784c1267d38ae2d4050a725111fe37"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6c95200a5fce603571c18d2757de906568cb82cc4b57de2af1be60ea81c8e7b" => :big_sur
    sha256 "c0667f0ca5470ff24aea666367b9c8999e74649a35c2b8e09065239e4b7126ae" => :arm64_big_sur
    sha256 "1f81ce5345aa8837e2808c7e69a29f12ac48890693dc46ba3418990f7aa71b55" => :catalina
    sha256 "a8861025ae532b162664471b417d3b6199c725f7fb265b043adb427c7d629af7" => :mojave
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
