class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v9.4.1.tar.gz"
  sha256 "73b12583ea97292e586231e1d03595da1a951a3a50763f6e017b4813980ed6e5"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f98b181281b18bb6ff7ccd51531538ac7706074e4377025e03330c9dcc713ec5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54de11df84bb1a1a310d7fc522eb569de41590b2cc39964c0a7c05f585d588f6"
    sha256 cellar: :any_skip_relocation, monterey:       "705a61ab39edeef70836dc34c565c77dbe8b915cd18282546ee5001eccbea224"
    sha256 cellar: :any_skip_relocation, big_sur:        "78d75e201a0f8bc67fd29f5cebc77b9cdb07e11f24426d8f9b82fd234203a73e"
    sha256 cellar: :any_skip_relocation, catalina:       "13b95842f086a5fbc5cb6e62befac8d4df9f1828a5ddb6a35b8bcb15d0d1d06e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "615780450e4008212ce7d07edcb25580116839783fe0845e8470da7e90bc92b8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
