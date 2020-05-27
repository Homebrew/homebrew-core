class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.35.5.tar.gz"
  sha256 "5b3fcb87a7c4b8992ac96c2fc6564231bbfcae2ea4ec5c4aab05d67ead9e0d06"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf56d27960763ea258c58253ebd9c1bf219b5bdd7f7c2dea5ff4a8ad7323ed2c" => :catalina
    sha256 "55d888068330d84f243449c6b8d57ce1e56ffff7ca64593a633b3f2aa2606d52" => :mojave
    sha256 "7cc5f1dab2fb8dd5fd70e6b68291f7c79e1da3f9f829d3c8434e6c94a94595a4" => :high_sierra
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
