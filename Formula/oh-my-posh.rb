class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.14.1.tar.gz"
  sha256 "864047a58290ae6b578e51bf163b1a79c59fe3c99dba1118b993f7f9545d53d4"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d87a3cdfafd7b4df0d3d0c70a9e629e0ba5847a4ead653a5c96672310718b8d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5aab5e4134f070961f110634a5baa72b80c23a61e81ad8e5c1f243d019c81120"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d6f5c3b67e60c69806ccaf629964df117b1a1d1fa2b02285a0ffa88e0b72608"
    sha256 cellar: :any_skip_relocation, ventura:        "4e5e0d13f2a30e9bcf4aeca880fb96448286e45a3a0a47c579e354c41d7b160d"
    sha256 cellar: :any_skip_relocation, monterey:       "892d7fa36ce469616f9ce26ae7ef621ed1e63cd5807b2b809754f7f415bc0c87"
    sha256 cellar: :any_skip_relocation, big_sur:        "b613a8520387484a8d31afe23f36fb4871d2369c4e33f673c63368b926001b21"
    sha256 cellar: :any_skip_relocation, catalina:       "001b3418577da54917dd85221bd792a0169da224dae7eedc421ccff24c25a9cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6451d2f1fa75b04530cec5b53bd9926d907d8db65f75e969be0867a182d0919f"
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
