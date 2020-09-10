class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.39.4.tar.gz"
  sha256 "c2994e3d501c62a25a38d81f49fb00a946625e9e7235616ad1d7e84ec62a44ea"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3ef66e2e96a63e26a52ba0284ac8289a91d6e9d92ce10c5870fbcb6b7e6725c" => :catalina
    sha256 "22dcaac1eca154d90819f39400dd444a327210f7a48d0a29440f5195185b6cfe" => :mojave
    sha256 "0f608841a25cacba5c0f943415e46f042aa99e060188080df88aabf0a69f221f" => :high_sierra
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
