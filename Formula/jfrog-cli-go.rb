class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.33.2.tar.gz"
  sha256 "b6682085d1ed19448e32bd208227229de43a85bb7e85653bc332c714ffaeb425"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9f1c266971a886f0776397af8b5d3b3523108967e007c7b87148b4cd21098a64" => :catalina
    sha256 "1afcdbff928c451c51e656e16d1ea4e6d4901d7ca829bbce66d46e42920d218f" => :mojave
    sha256 "9034baf5a00798030ed179bc34e68560252bbc2ba399b800a48f78371c8fe9a4" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "run", "./python/addresources.go"
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
