class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.0.0.tar.gz"
  sha256 "7cd9f877a42198294f29004de0c9dd5afd71b45561ea369655f71dc63fa7dc8a"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "646f356a875bdeafdb41744c394e1fa0b8db63b42aeebf323661affc04c926bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68d95f871ff5986da71696c0998f4302bd3bc38c19b1988b1ff883a9edb779bc"
    sha256 cellar: :any_skip_relocation, monterey:       "8e080e020df50cd20ab0f7f2db8cc86ba0c0230ed9b60de442ec39b6c36c86af"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2ed6d9f8987f430b597edfe8d8f130924cf626d645544df908b080b720ae37f"
    sha256 cellar: :any_skip_relocation, catalina:       "d7d6a317377b3fd150ca7c8c671693379d3a59fcac4269a7eac20b93d74923c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82b2cdbb9d338be7c260857c1d22beb65aeab3d78ad77092465583d9ab301b73"
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
