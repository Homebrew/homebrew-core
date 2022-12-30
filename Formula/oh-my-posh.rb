class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.34.1.tar.gz"
  sha256 "b057eea15a0a850fa4b1f25c8832bf3c017d4df30fab19bcfd46d6c5a7f21a1d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e02fbdff3ea55cb96a8cb548fada2ff64d192d1a2643478102050ce81aa0cbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c762085ff862921d2879fa360dc6689d1078f5c2ab1308b48aa773fcc245720"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0071e4197a4865f2803a6352c09724ee988004ae2b59709b8ec100f139327653"
    sha256 cellar: :any_skip_relocation, ventura:        "2b628a56db6bc41aeddc8669bfbd8cdee5e3239790022f7a8461798f3a80d4e4"
    sha256 cellar: :any_skip_relocation, monterey:       "c19f610b8d99c955c62ca6bfd43d46487d230198066a0e3479e8cbf0cc56f418"
    sha256 cellar: :any_skip_relocation, big_sur:        "08fafb5daeb4c392cde06519848e1fac5be252bc7ca6d30cd90d0ed27b205c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e1b40372991c316f2d29a077c470ee98be4c38478352efa7eefe487b627109e"
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
