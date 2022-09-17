class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v9.3.2.tar.gz"
  sha256 "023f7a923318433fd6cc87d04abad27d88c01a5e09411897bac8e6498be2ccf0"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cace701e48a2df6a51857185dd007588a174e0b05539dbd22d74f4fba4ea7b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0caa759c49777421f7dff383f0870ae003429c6f1f85e3449c60b363434b303"
    sha256 cellar: :any_skip_relocation, monterey:       "47362ce28ebd07e3dddc155721db088e8194995dea703ae3c9335107198c9e49"
    sha256 cellar: :any_skip_relocation, big_sur:        "5adedc5fd1400dd9576936051f3d736cfca60d0486436b992903bcdbe7205090"
    sha256 cellar: :any_skip_relocation, catalina:       "b599f41503f9c2e86a219c89bd9708c532b0067a41d4deccb401d3b47f389504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0b646755ea9b090980ede987a710fcb6dc65a02f40e50985902c2e5353182fb"
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
