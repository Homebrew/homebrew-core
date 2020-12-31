class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.43.1.tar.gz"
  sha256 "8a4a2e2e01b59347a969446832b47e27cd7db75a14cf7a87661a1df73549c7c4"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "aad8e585e80917db41f3bf946f2320cc96d2a3578619e88ad0280338430e9bc6" => :big_sur
    sha256 "cb874aca025edb09508ebe68f72d4105afb009996a7de738490e3e916a91c24a" => :arm64_big_sur
    sha256 "6d3e399aa7acfea9323e5a66564cb6104da1416ffd4d8b084f3e059583d93ee9" => :catalina
    sha256 "1af1ca94789aef08275e5807b43ffdf9c8dc2e923a4b6474716ba9774094f315" => :mojave
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
