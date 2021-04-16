class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.46.3.tar.gz"
  sha256 "2852b25744f7767b2b5bfbfa559b8e1876f06485e624966bd2a0fc9d48588ce2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6858bcbcf47052bc70caff7d03d4bd43c0948a6e87eab637864b92ab1315546e"
    sha256 cellar: :any_skip_relocation, big_sur:       "b5a80deca0ee21f74628b10718afa1472541de1506aad9c17caa42af6281c306"
    sha256 cellar: :any_skip_relocation, catalina:      "6ba15993809454b96d54d7a0f2ce8421e893545293f804a80c3e959d4ad4e5c3"
    sha256 cellar: :any_skip_relocation, mojave:        "7aafcb906d400b2135514b9b68f910b4cac26171556d26660c789f17b658b079"
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
