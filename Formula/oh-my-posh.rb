class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.34.3.tar.gz"
  sha256 "6d644e07a6d4dfaa51fd4a22c047c5dadaafb13797602265d64c74bbab180b96"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b916c4ad7754e0798fac237d79c18813f9db5c7ec2db94d7d2cb5d78e1f22ce2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29cd4cd789a1cdd6acf060503b1f4d3e81b6538492060a5d3cb3f8205d74954e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67c1367149d9df294953d5edc838b986509902eb6b6c8497c2ef39a19a820f7b"
    sha256 cellar: :any_skip_relocation, ventura:        "dd0a87822d8ab2347fcbd7e318109fd34f34d8c910fb233b5c550c5f88273eca"
    sha256 cellar: :any_skip_relocation, monterey:       "a5cef79b938ce0e43e2752bb0af6ee3324dca276cc117df841e51c93d597e22c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fa47483f0246fd1329c8cdc6d9af3c1b633ba9e9c55711d3ad00d6a587d62a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63dd8bfbca696822481b4b88c25585444ca38e3f145eaa0951d8cff16bd898a1"
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
