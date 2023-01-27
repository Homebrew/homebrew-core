class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v13.9.0.tar.gz"
  sha256 "144cb62a534aacf227b4179a5d53389e550cc90d02905b0539a169bf47685414"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da5734f7cf6a4607e0db7079a7a1883ad4473fcfcf0936ef39072f5bc30b7137"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c6cc2874895aa07884c4641b3d91a3efaee88d59cf8ce9f2bcc82b7457d5601"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "029bb2787c2f2e229f8a562f7c8788ec69db444b729c6554465b7939a779544b"
    sha256 cellar: :any_skip_relocation, ventura:        "6e67f330fd4368bd7a0b5c7d0dfb1d532f34179e24d147b3e806016dd4c37571"
    sha256 cellar: :any_skip_relocation, monterey:       "b4aff5678c336db60fd2b63fed93baeae1d06a5a88cee06d7830271404c88e97"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cfce5f2602f5d237457e48d8bb06f7808300f936b6b328cedf645f5b55c5dac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cec4b57edecd0d34a60a3ec2bb578d8d93848abf420b2cc4167c75852c2d45b3"
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
