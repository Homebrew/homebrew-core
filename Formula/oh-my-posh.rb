class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.29.3.tar.gz"
  sha256 "44e1ded53f02a570a17eb560f771da4ded3aa65a806e77c7902113b7be20d7a1"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b845a001cd1d954b23daf32c0a10d12aa86dc18da8ce22100a8a1da4137692a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc5f06469c0d3e246f06ec50c445e30a82511b83a83f77d31a4f50ce8240c1ce"
    sha256 cellar: :any_skip_relocation, monterey:       "adda0dd59015269bef42fd639c514c69d6a880efcea8872d70c7a42817d19dd3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f0b9d2f41db6a18281017abb119bbb9f7ba86bef7796edfe1d3d762dcc48c51"
    sha256 cellar: :any_skip_relocation, catalina:       "18dac9a972b39741cd0c3f1539afff24b3841ba8e7a4cfe14a07f1612db10b65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bf3bc680c845be4d99809f06f187ac84ae02579ca1c96725d84be7bfb6dd658"
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
