class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.36.0.tar.gz"
  sha256 "5d35c32f16fb4f8e4f710aa31f4d68a5cb4011ee8960fa0ac6f3b7300b581e1b"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "849c14e028f21b51f85a4107e3c69afba42c2a9e83cf135533e8d977eb0ee0b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11e8f488da530332c5a5201b5057af5925cf2a74f08a8856e09d7005720a1607"
    sha256 cellar: :any_skip_relocation, monterey:       "5740356554bf65f71cfb0fe2bb579f23a7846992c038904d3de78af3f35f783d"
    sha256 cellar: :any_skip_relocation, big_sur:        "13e504dff7e842504476d130d09f667af5b516f88a1d085c88b2a06c692b7cee"
    sha256 cellar: :any_skip_relocation, catalina:       "f8948b2d26c3c17279476c6d9782eb669eeddcc894878239bfde39b666e557f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83be408c3b76c4443d4b93cfb12750c4e236429b519c06281087de098394305d"
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
