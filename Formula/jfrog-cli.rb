class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.46.4.tar.gz"
  sha256 "4a0c69906c8a78f0631ef86289ec21588c2d37369cb0cbc1f6f80e899d731529"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6d25c4b60464488f68e149f41ad8c52c199b63d220bb418df9d4b540c1a97e28"
    sha256 cellar: :any_skip_relocation, big_sur:       "34c0f3604f61b9ae7ea835134f19902e893566482e9612fd97e5b8570a1acec7"
    sha256 cellar: :any_skip_relocation, catalina:      "38813277d4ca1dc0ad877d0cf7c343c966448190e41570f5256ea2a2dba0a4cf"
    sha256 cellar: :any_skip_relocation, mojave:        "4847cb82c3a5a370d75ce171fb581656bbbbd19a13915c4550bc7e44cc8b6dab"
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
