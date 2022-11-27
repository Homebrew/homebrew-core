class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.21.0.tar.gz"
  sha256 "5e24f0e98a88fa245cd7365b4564a608089acfcc6a7656a2af2bcf17d172d744"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f6e8acdc9822d2d452e6ead70134a9551d82696125414d2e4cea70f91baa251"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1693f4b7a80210ba51e474ddcd8a4449a4c488f19967315c8762975d85aca93b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd5020898ea3cf34c9dabc067e16258d6530993c115be4769e8144a22dcca605"
    sha256 cellar: :any_skip_relocation, ventura:        "597d502de3aa448201f9129d0abb32432d3e38a06faed6e93983e7116f3c4488"
    sha256 cellar: :any_skip_relocation, monterey:       "e922b38fdafd2ee969b6176de6c09b3e4a85bf905a625f73860098f5ca4ae608"
    sha256 cellar: :any_skip_relocation, big_sur:        "47bfb0f2785f3db3283ab7faaf9772b7521ce37cf686c05e2983c59b3bdf9615"
    sha256 cellar: :any_skip_relocation, catalina:       "e824916835ce5037b14039fa37fba0f00408a994732df570b5403ee221c640fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0a4cfe251d453e32578f8084167322664d39f626b9d2fe8d3eccddb7b4ec163"
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
