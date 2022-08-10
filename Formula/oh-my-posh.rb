class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.29.5.tar.gz"
  sha256 "da7cf624380dd42dd8dee57b8f3f0c5c0b9c6792a482dcbae0f70ce37589e643"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "890bcf7b66aa449752148304df68e3ad1cc430c8ba22600c15179aa0bd8e3f7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86942a571d1ba4f2a85ca59817e0f35d626f5ce67c69972d26ad94f38871f723"
    sha256 cellar: :any_skip_relocation, monterey:       "704bd1f629a60ffdfaddf786cf4bf48fa87f26a6ec36b6b71cc044538567dfbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "a64e83fe902aafefce38ca3e38c39381bedb858ed6666b1e6fcdffc14aeaa964"
    sha256 cellar: :any_skip_relocation, catalina:       "235db2f0634966374f75e92384d603618f650a51b2372759dc58c09f027af202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b78eebeafd1d6ab3e16deb17f238a3338b62a7ecacb15cf8381f991bd8976595"
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
