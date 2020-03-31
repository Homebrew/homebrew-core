class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.35.3.tar.gz"
  sha256 "5ff83aa5e8a47915da7672eeb29f0660039aeae9da93bf52067a06771a95fa38"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9aeaf0a3e0c3189cc9d22561209042563f890e9297cb555e84e803fe898b57b" => :catalina
    sha256 "1b09677e3de8d6109e7ebcfc4e17bdf61529d0d96b09092dfd933f3bdf22cfb9" => :mojave
    sha256 "2d2e5a298e3ec29f4974c9fe844913fd8ef50345b78602ac088f85f926c7b891" => :high_sierra
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
