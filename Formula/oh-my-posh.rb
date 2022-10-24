class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.6.8.tar.gz"
  sha256 "6a77f1af47bac02640aae4add70b47273cd2087dbc6e14caff32a8016d7ae282"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "412e6f7b1c19545848f3c2efebdaebb97c9ae173f4fdcbff0cd92da8f3a28fc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "446dabfaacdfcc714482549ea43c47a310cf02419b298b165859ee5e721c2e37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bcf5a27362293501ca92bd63f6a2c735224261e7b9b40a18e04dfceeea87f21"
    sha256 cellar: :any_skip_relocation, monterey:       "9bdcfd71b0ba9d965d85da6c078fe9ec6fa8767200c878026b4fbdef128a2a72"
    sha256 cellar: :any_skip_relocation, big_sur:        "89437ff3d5287e734a8656e651e957e71ef52b901d8a82de056d98d3ffd3b811"
    sha256 cellar: :any_skip_relocation, catalina:       "66a1e426c8c33b9811d9e91ea3dd84a6c8e6c62155bb4c320235b277ed383a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a982e6530cdbd1782611ef790950f3993075a7769cc68cf1eca085f13fc372f"
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
