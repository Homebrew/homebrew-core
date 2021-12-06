class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.8.2.tar.gz"
  sha256 "eef227f5d222804894195759c70ef09de1d350467439223c665872aed039cd1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87be69a54fd84c244f1ec8d470854b58c454d5d11089aef504879fabac0010ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e43592d4200f1507788b7ee7ac9a4b20b7d08bb4cf675e7cc018709c6b4c0a4b"
    sha256 cellar: :any_skip_relocation, monterey:       "5b209b2808854b7438ab6dbe847f1c2e34685b6a4ec35100c8b8aabcace3f41c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e82e5e4df5f8aeafca67be3dc34463b7f5a1d7ab99738ccf3428e4c807b1b3ae"
    sha256 cellar: :any_skip_relocation, catalina:       "bce2afa6e3fb679d65a68d9da0e3eb7a49ba1b484acc1298b0ce7823c74ce682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4914d4e177be80268471572d483eace35dd629fea53e485c86b4eec4f6f94a1c"
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
