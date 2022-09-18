class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v9.4.0.tar.gz"
  sha256 "62edbab6654772c14fb6f8b2d60a60ba213bfb479ed407e3a172c96ac92df3dd"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52acc3b5238d5578355bc2fc0bf65c5efbc5f9d33aa8a3e2a9803329879f0ae0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1d07e5809f01beb95c14db299649639c5026683212bb36548c829075c99cece"
    sha256 cellar: :any_skip_relocation, monterey:       "3dadca9b51c80db7d87103ba4e6f65d12ad3f5bd030aa5c290ecb999a14ce359"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb5c40c0be9dc948c5a1283e0562391bb63a4c80d4e8d952a189477d6ab7a88d"
    sha256 cellar: :any_skip_relocation, catalina:       "90510c5cb658f055a7c4c40f09583e92507f3367c6fdac00ec800ca1c64f8a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec975fb22c3cbe093d704d685b036b46faef82208d3e68d29ca5baa109b3a022"
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
