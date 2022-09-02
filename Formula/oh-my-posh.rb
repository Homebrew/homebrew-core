class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.37.0.tar.gz"
  sha256 "5e3f43b78ed3cafed720b84b76fd18cbec18b64fbb520cccafb1526f1ca7faf4"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b0b4fc496b36fe631f9888f69d33bd2b4a6c7ce94dbc34ba07f986dce597fc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c7687174167607749c23277ab57d35310c40ae896148a496214121cb6701edc"
    sha256 cellar: :any_skip_relocation, monterey:       "f7a02c3c769d871458ff5421629c0de0ae890b1a95aa63b53d792055b5d16fc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1a5ca1bd66cb043e5687feca7e4c8eb4495fcc37af8d145a586797f5e037a45"
    sha256 cellar: :any_skip_relocation, catalina:       "9bf7cbfcd057c5643aca8456eeba12f22535ecdbadea268a80d63c0b58c0e394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebc75bf9cf502bdca286623fbf2de5e61a689b07e7892ccd3dfdb5174b054399"
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
