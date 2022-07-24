class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.22.2.tar.gz"
  sha256 "5abd74a75c648f872130e16850d1e7b89008e3c9b70b76dada63bc2bef553366"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04782e79c636814dad9975c183ebc83a0e2bda5acefbab8b28e1d7b566f109fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "736217d1e5dae57613f4c6163ad589ae26aa2ddb52831f710921397c0ec9173a"
    sha256 cellar: :any_skip_relocation, monterey:       "a3d6939fe8f8a870fa2b4a7de85f2323e6c1bc1c3abf7f7a6764db9bb76905e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebcdfbdc1be615270c08c8d565cab2188230bd4a8fd49b11b76a25e80d04518e"
    sha256 cellar: :any_skip_relocation, catalina:       "1c0d5e2b7efbb3fbcebb2f2514026f2be45fadf316fe955f87918d1b05e519c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28439ae367c354931c7da6623fdc9b71a9bf9465893dddeb1e8dae465867aed8"
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
