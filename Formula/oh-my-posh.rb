class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v15.2.0.tar.gz"
  sha256 "9b47045a236cf3479e3ea688a2fc023ed4a3b55c132b0e1bd2897b4d8b936f1f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7352565d1030a26a394037f61ef7d37d5a41b944284cb1f87c92c493f0fb392b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "275bae3d1629440bf1e72c8c8da8f6d7cebbd182d57b1fbcb0b559eb76f13fbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60d109f5a65a2ffe5d0a3ddf89c3ce4250a717b081ffa16529b852e5f81ed0e2"
    sha256 cellar: :any_skip_relocation, ventura:        "4286f80221f0ae43b3ae36507bf024be8a59136dc9d49aab13f368330fd77284"
    sha256 cellar: :any_skip_relocation, monterey:       "9fc745943ae9b629b22a96e2ca1008115bca07c2554bccdd6505d97779b52409"
    sha256 cellar: :any_skip_relocation, big_sur:        "34193fa39072d7670b8595472c385bbf5792d108f6b1c95bf906ac0af37805c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c45d3ed2e2dad5dca1c3e54a46f0e12cb99008e82af8d49fd544d8ff9061660d"
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
