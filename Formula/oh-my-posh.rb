class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v11.3.3.tar.gz"
  sha256 "2180fda158af1c887118c1cd1466ba616235dc4a826234f1f10b6b6cb7252a93"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68d3ac4737ed7f1fd64c157f1bea5fb1eefa40731486d909bec0af6013b18c0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "614decd8ebf0d8be7d3342c365bb0e90398a3636cccfefa6870c569da754c6e0"
    sha256 cellar: :any_skip_relocation, monterey:       "14bfc55b170d9e9cd5a0b6cfe293bcba6639055385bf6496aec7449e92adf059"
    sha256 cellar: :any_skip_relocation, big_sur:        "12c567956d50396f63de8c31ecb705d558b21d51396f49b02e620b47b3b4ae91"
    sha256 cellar: :any_skip_relocation, catalina:       "1d841798774651e9b70327cfe6b4dff6fc64e3a65d0fd78a0b30100793bc4501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6a5e343846d532fa896bb26ce7d4eb04f6efa91fd2a9995ad276c35f76ac742"
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
