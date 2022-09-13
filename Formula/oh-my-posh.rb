class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v9.1.0.tar.gz"
  sha256 "b6625e25cb40f7fb9cd80918ce3c4222ed706df5814ae971c8e60823d46b8de3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a6a75850e3fe1e239da16870b6031c4a8f4efd3434a2c062b59e1685c28d202"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef6b20bc2c8ac6db9913fea48d837e867aeaf79ef26eb7b2f862e3dcddc74d6f"
    sha256 cellar: :any_skip_relocation, monterey:       "6e210960ec5d17fa9b10456abc07ae61909beb0779be7593fcc01c54ec1ccad8"
    sha256 cellar: :any_skip_relocation, big_sur:        "1569bd59b7fc61f01d8f7a9ca8f118e68518f5f643726326c587b43c355a952e"
    sha256 cellar: :any_skip_relocation, catalina:       "b277e0ae2f653b1d3a9923f68a6a92e5be7ba92f8f545a83e5a954f306b1902b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb574b9277ad255dff4951975db6eec721204e79469a5f0809f84a19069d87a"
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
