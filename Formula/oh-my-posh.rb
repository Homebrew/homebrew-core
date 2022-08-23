class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.33.1.tar.gz"
  sha256 "f7cf7c3c38f7079804585b1af428a7c74df7aaa7c8864db1be730650b9e408e3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "407c8d757946c61afe55e44a01d02e3276d561aa1e72fcfb07fe6d1466ac8655"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "087cf5237a72eb3f22ef5aa750ed46a1cf215f33dd051707bf2e32224a9ef5e9"
    sha256 cellar: :any_skip_relocation, monterey:       "3a2c07c2b98b9d567dd260acc1b5638df81993fd4c84510c5207890e1289fff9"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f9dae02f9733c879b668e9f0771d9211425a9e02580d5760005468cf88a987c"
    sha256 cellar: :any_skip_relocation, catalina:       "64564110927083509469f7dfe74b471468bfc1c51daed1c3dce1ce450836859b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c33a5c68542ba9f77553cea90275a948ef1407c69ec1f184dc99b0bde9a4a42c"
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
