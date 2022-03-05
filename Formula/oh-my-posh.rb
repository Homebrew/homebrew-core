class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.32.0.tar.gz"
  sha256 "5a217540a59a47409a9b96053c7733109d828202daed507b43c7dbff7810774a"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6bd7fa78d14d6b8f315ace071f31cdb6ec562a98ddf97336b79e4bb0d3fef7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a277777ee452764b100ddf36275d28cb4c502b16d67687b5e558614d19e18df9"
    sha256 cellar: :any_skip_relocation, monterey:       "80ee2f00720784220aeda9134b21e632e7d0e09d09c971aea8fb12c721e710fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "e96fc2218f693535f3a768a40117acadb2977f3cdc79f8e0aa6ec81378ad91f3"
    sha256 cellar: :any_skip_relocation, catalina:       "f32decff68571649ee44d46c1e308d8abfc2c458a3c638e721cdf89ad27916af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "977e122ba0f084e8832933b14538abd3090d11127d7431bea127e1ee2eac7241"
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
