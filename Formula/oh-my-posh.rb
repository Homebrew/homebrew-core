class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.27.0.tar.gz"
  sha256 "1bdb6663f92bcdaf2afe645e798acaaae6d4df0dc3da1bac9be9e9202937efa4"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fe435e58b380f6b3b21fc8f788d561f2d6b2b234056db1ec30676ef17a56819"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f64bf424033f013618842f8e7de307da4a9dd6498a575a10a424fbbf7b63c7a"
    sha256 cellar: :any_skip_relocation, monterey:       "1ce9f5d35926a7fa8dcbbb462a9134bc553169c597c603612fdd217dcb122216"
    sha256 cellar: :any_skip_relocation, big_sur:        "09de9bbd9f533db0d2cfa486894ee59e8feb0641d9cd141fc5f39d06724b83c4"
    sha256 cellar: :any_skip_relocation, catalina:       "eba3b2bcfc0f7700207640b9143b7ed19aca0d51b7385dcf7543af663e7ea033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a73e14744555c2ef8ca88fc4317e23a6c9efda0e68b2959bf2f0f020e711ed9"
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
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
