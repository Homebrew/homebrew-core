class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.6.0.tar.gz"
  sha256 "3a8e1037317edb82a6d68ae552f2e094876db23c86f97a04925429c5d78263c0"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83f245276cb92db5b2272eac914e6f5d7ca2a6e600b55e5ca5cf2b068522e0f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65d976b183a9806d43310be874fa036d0563ebab8119f6e2deb40622dc6cc1c2"
    sha256 cellar: :any_skip_relocation, monterey:       "03d3206b602028cd7c0021644f61ccf394a9d4c7eca7310adc9d2d540b543f44"
    sha256 cellar: :any_skip_relocation, big_sur:        "3db0514700a8909fffcc6041a6cf753b58e1f1a1a246d4f1b146bd8f62d1b666"
    sha256 cellar: :any_skip_relocation, catalina:       "af04bdb1beafd00724771ac95cd17cf39b760e7184a6d3cc3410a4679f40dccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54f66c153062a4d98fbadd3753a03a8b1ff167a2b070ddc65f977964af55b2c9"
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
