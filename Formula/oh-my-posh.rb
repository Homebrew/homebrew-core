class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.22.1.tar.gz"
  sha256 "6015b57ed79fb69c3d96db6de19931aac588428bcb0346bef8c0175dfffd25bb"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ac0d76418c75b5c5a99a85c652bb669a57091c78358dba37779636f5d59dd9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bac0e3f08c88707ec0e72483e08b4d65fcf4be1758e281015fd1860a72cfbea"
    sha256 cellar: :any_skip_relocation, monterey:       "858bd97abd875059d6b656171a4ec32e43151deb53d064a4c135f6b6c9572bc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfbe2efbb6c71157f0376b0cac6ef48796984305f4e52a133158f634a0e54a75"
    sha256 cellar: :any_skip_relocation, catalina:       "02119f1787483ed13ca67f592aaea08bf10239a91239c1be4e15c6b40d890219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f320b327d8568cd4ec7b69784e7e5f1556a40186d9bde61caa0d2fd07d5a363a"
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
