class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.52.1.tar.gz"
  sha256 "c234566ea3fee4b11ca34ed0ad11f907cb4cba45d75f618e86d2fa0d7bb6637f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "952fe4f271e52359ae7eb32ee333897da1c85610f58f45451f1434c075858416"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa7ceed4298938fe861bb88079a47fdf2dfbd1d824f5973b75caf91261a48419"
    sha256 cellar: :any_skip_relocation, monterey:       "7273079138868c50103408d44b227f29888aa9d2a39ce3fcc3ac97819cd9a0bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "14f696f8ce6792b36538c41ad24d0b6b7434e419353c10c9bb4574e54931917a"
    sha256 cellar: :any_skip_relocation, catalina:       "d66f3878abfef4299eb14f8c5cf2c3632685bffc54eddec465cc891248ce9f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "826e4439b2e0a2a9fc91555adb09368fb36c8ac2a4ca7a884009b7fcda7642ff"
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
