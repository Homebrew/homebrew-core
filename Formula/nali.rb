class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/v0.4.7.tar.gz"
  sha256 "a1116c889f423a29b2c9e3ae84fe7787e80538a2ad1e6f4b6be31db5d4f7a0e7"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c16ca7ce26ecc4d6ba8b42603ecaea7313171bb5ca55723c17d4c9fede6c1bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fec7a7576443abdf105736336ec9e6eb79ed23da59e9b60ad18413a9478331b"
    sha256 cellar: :any_skip_relocation, monterey:       "a60d4926f9e7d07ff9e462a5e438f474585daf275b8443cd799fbaad088a8bca"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bc421f5d25991fda289f93bbffc1d4f66e17dd64534f3ed9610d5dce817b206"
    sha256 cellar: :any_skip_relocation, catalina:       "0dc48cbce0f3249a306403840a76535720de9040d4322ae81f5ab3942c2bed5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b4cd90f2fe6033a8882c326d259bc6349e0e40bde696d656680f56f17ec2977"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    (bash_completion/"nali").write Utils.safe_popen_read(bin/"nali", "completion", "bash")
    (fish_completion/"nali.fish").write Utils.safe_popen_read(bin/"nali", "completion", "fish")
    (zsh_completion/"_nali").write Utils.safe_popen_read(bin/"nali", "completion", "zsh")
  end

  test do
    ip = "1.1.1.1"
    # Default database used by program is in Chinese, while downloading an English one
    # requires an third-party account.
    # This example reads "US APNIC&CloudFlare Public DNS Server".
    assert_match "#{ip} [美国 APNIC&CloudFlare公共DNS服务器]", shell_output("#{bin}/nali #{ip}")
  end
end
