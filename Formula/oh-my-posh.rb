class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.22.0.tar.gz"
  sha256 "6d16772eb41b49167ddc03997f94aca9a4d91215198a7a61c74b66ce05ee16aa"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "155d380453a35a4c8733c8b3b633caafd991cfe4f5089aa234c984092696a243"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7709bdd9885af5ba91b56c79f9fe045b8c030166906b1d40ea1745546ff53f1"
    sha256 cellar: :any_skip_relocation, monterey:       "89c8f54dc5a99818cc16cbfd9a6794f40380479fed389f101dbe77df6ba10ba5"
    sha256 cellar: :any_skip_relocation, big_sur:        "abe4e5896a4ca313ce8728647f89f5dc26088ef93ead4cf047b051cf615a2086"
    sha256 cellar: :any_skip_relocation, catalina:       "71d81c41cff8105eba86fdebad5d5933659153b2c56c7c7d0942d5afd0231047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "104d9f70a236bcc2dfec56d07e27d023d10639f4ae5289de31b74779b72a99a7"
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
