class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.19.0.tar.gz"
  sha256 "569e8e39792eea00be706cfd68b801b869499ed7f6c97c0c7067fe1472017c56"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a6e276d882f628bb9ac0dac4f9e23fdf224b4b7b655a1cf62cd66256a3d9a51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eba51f27152d12dff002de665bf8a145954e4d190d9b8af362cd0febb088e953"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45b1901d76aedbca7b67be50710f2e92b4520ad42f06ef518ec143ea481b8a73"
    sha256 cellar: :any_skip_relocation, ventura:        "44a6d1a135935e29aa892b5317c5840b8367562605e28ec5299afe2c9c3ffde3"
    sha256 cellar: :any_skip_relocation, monterey:       "a9a089a85db75c8dff251543cd24a7078d59d98decf40568d9e9c74fda6fbb85"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ce79fd9fb5d16c453cde16c2521c42a76a2384799b55a718613f543c3a112b8"
    sha256 cellar: :any_skip_relocation, catalina:       "50dddc7f21c9e2922070aed8221192b5ede3dab398ec4563bd6b79cf5995fe3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff1516518707983435b6991d9713166d056aa8e34c4fc30dceb937cc33dd7e2a"
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
