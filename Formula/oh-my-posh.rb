class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.19.0.tar.gz"
  sha256 "0704af3df74865f0d345e7e10f93f8fa71f92e7279a0b18452f802b1474b6ae3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73a9bd323c91a6cacb5993253c20b919920a5ea8b58b88418e4f4868c1fe29be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9688780b69c3d024449d7274e219cdf0a4e870b659b35b2a1e9e8cd81344a27e"
    sha256 cellar: :any_skip_relocation, monterey:       "d97d938f5099caac4d8b3cb4437c574d4eaf28ec6fd0270f0173036ff7a480af"
    sha256 cellar: :any_skip_relocation, big_sur:        "327bc4f6d52b546831478f5dafa81566f0fcb08271398f4a3a7f7d9f4c21c718"
    sha256 cellar: :any_skip_relocation, catalina:       "e72c8e7714b6e93042983eec2fcf4fcb58da6a0aac6f1ee27be9480d651cecf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c77015a99c60385a73b3aadaf578ab506ad85c3047c2b6b8ac376e85a82d7bc"
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
