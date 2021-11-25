class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.6.2.tar.gz"
  sha256 "d8d84c0b3e421fe2b8d96ec20eefaf52f3a077ac06ba0fc879298cab8c3ae4c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b83d02b67654906e4269891e80f5020e33b7b16d2473d59f66a339547c4e8f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1741cfba061aa5d5f0c5cb49824904af89a0debc0a7e69e33bb13b474c65161f"
    sha256 cellar: :any_skip_relocation, monterey:       "48fe7fc47fb1b1f589825ae0ab3f95143c345eff2fe8668e10ea3ac07a3bab11"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbc01a101b218ef71931124bef91e6c35086db7f3c46a0140f7abbde5031b65f"
    sha256 cellar: :any_skip_relocation, catalina:       "f9aaeb30c44f492d39c29e2f89afd9aede08fcfa52f858691123db82c46a9d75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d505bec5f63b392567df1f582f7637a839960993cf5f02f6f8f8a3e64e2d886"
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
