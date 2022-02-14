class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.18.0.tar.gz"
  sha256 "ed38d4613b5db07f0b00ae3a8fdf4597601edbaa093d598a0c0270e755382a03"
  license "GPL-3.0-only"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
