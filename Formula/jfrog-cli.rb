class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.48.0.tar.gz"
  sha256 "5986981b92fa6efee633fd73723428a23d111d8d9f739cff695183405b75fd6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "338811ed866249597d60688148a1da08430a98fe6847e16ad473f755d25cb35b"
    sha256 cellar: :any_skip_relocation, big_sur:       "269b3862510a48c65e402eafe20f66721c94e5378f2aa7b8c0af0a93d174e117"
    sha256 cellar: :any_skip_relocation, catalina:      "12df2ff895bf4c91e2f0a223a7f59edbcdd2fb99f6095f1b37f075a463554c0e"
    sha256 cellar: :any_skip_relocation, mojave:        "adcd50f8562441cb43af4c047c3a54bbee7dc33ce5fa9573359db18f9647dab8"
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
