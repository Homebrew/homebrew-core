class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.22.3.tar.gz"
  sha256 "9af46ebcf5625f317870240a46ced3c45ff9141333445b63f26d437afd868f00"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac9315040af499b7ab22d44cbbc21626f4a4ae17882e26949625ed7cc28b699b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e336f29bd093a64d05797f00beba36c4f4fa45a38d93be6d4fe5a8bd4daff80"
    sha256 cellar: :any_skip_relocation, monterey:       "3b9c72927b5a1fb8b650cc9bcf8f791f1075661c1424434da76fccc39ff8b675"
    sha256 cellar: :any_skip_relocation, big_sur:        "5689bae10b562adfdc30de8d0fca97f4cbdad9070d260b87a541bdd1a65b626c"
    sha256 cellar: :any_skip_relocation, catalina:       "16147f607fb2358a4c153127c7eba3e39c4aa2337f2d964ae9c37e786aa0fe44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "427ebf7023a73d273dd9a579f9696f7710385fc017513de0a991e35d5f6c8ff0"
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
