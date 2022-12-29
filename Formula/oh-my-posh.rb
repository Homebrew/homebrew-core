class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.33.0.tar.gz"
  sha256 "e42df5dc2f23032722e07c8013fe8b5d52249f6fce299f2d1c9d44f665231d17"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9aea5fe08bc635e032ffaa6ce2b705bfb3172366a7a3b29f1c9a38f9bea68e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c319d0da5158629fa1945a46f65a6b3d8323caaea53913752f23a541f4521f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d83a4e2fc75a1506241d7bc4d5992e2bb4c73f78870a028f284813bfbb9eac81"
    sha256 cellar: :any_skip_relocation, ventura:        "1d4831475c6fd8c4463f6e20480b655ba779e1f314010e39df7d44005e746fef"
    sha256 cellar: :any_skip_relocation, monterey:       "58d186b1edc8a55248ad66c5c9bfd760f4e9cecd8f1c547735b3f0672405a124"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e86be42268909e9d1d0507a9d6538382e03bd67929ea1e102dd1d9981d0b9da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8c807800ed1b80b0f03085171e4000ea885e9d41187cf5673cd1e956de07ead"
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
