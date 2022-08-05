class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.28.0.tar.gz"
  sha256 "dafd940ef6db98eebec8066e98e339c42ec6a96ce154be8842b55735cc07b06c"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c45cfc315384a5c56564f1cf13dcabb1bac00c7aaaef6f58f6dcff30b3180e9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c6a04e21ac14a1d82b163b31cb5ff940d6540afa8473a2153cce8f08eb54a71"
    sha256 cellar: :any_skip_relocation, monterey:       "c3e3106484fdfdf9a6f568a1b79de055f51c813006df290e43b937b7dba12582"
    sha256 cellar: :any_skip_relocation, big_sur:        "6dcb2cad84dddef866af9c3253d3b06f8b95aeb05feb69faeea851a809f7dc4c"
    sha256 cellar: :any_skip_relocation, catalina:       "e4c799fbfc3c183c415c8db9c5e30ba8443f9d455ff3f29016bea8c487f661a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bea5330b18f6759185921ffef44c3b619879de130a7a360e0116af1ea45215c"
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
