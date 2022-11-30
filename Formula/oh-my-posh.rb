class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.23.0.tar.gz"
  sha256 "c9bf15f9049252f9d591410e6181640b9cf17f34997afda74fec159dc5327b99"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f44f067606786fd0da36a9aae7d0ac9276eb2a30df16f046e32653520ad53e23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6236d6973b40d67ff144585a9558bba656a8c878b4f13c7d07e9d98a058e1049"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8619a5c1cb8504680c7aab357f467665e2ea84291df446428d73713c79a36774"
    sha256 cellar: :any_skip_relocation, ventura:        "d421ce43adabc667700fd7a29909d735df0faff1c465aa7c7101b99d543536f0"
    sha256 cellar: :any_skip_relocation, monterey:       "b5e5efe94e13f7e5b8f8825da2a3658402f7e737e6f5e75259264bc657318378"
    sha256 cellar: :any_skip_relocation, big_sur:        "175d13c236f51c1a3bb2e5ac25062aee9139c9114e950357df7affbc91d55c63"
    sha256 cellar: :any_skip_relocation, catalina:       "d1c946a8e3178d249a09f61a7a9b0c1cd701b68e383fb5d05e6457d74123080f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28589e42377bad9c3155152d9d9524ee1cf1facc261d3338f24a6f19291f2965"
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
