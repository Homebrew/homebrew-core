class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.10.2.tar.gz"
  sha256 "90a67b46c53fc10f59504662601a17bb3d9bfa9e528512768483183600116c4c"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91a75c20eafc34868d1d7bcbb32a354e9f42303ab98f55af5098d6215024f2fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b54f74cd28afc5858029509261fc3ce3e92c5965b680cf7bd0c7c6e0bbb4fad7"
    sha256 cellar: :any_skip_relocation, monterey:       "b4f0402beb3acdac36ef33358bc331375d854dc7012087055a30da9f1f46db36"
    sha256 cellar: :any_skip_relocation, big_sur:        "50f6d159645342bb32fbfcea281cb0f47a312ba787b40c33c03dfb1418d3bebe"
    sha256 cellar: :any_skip_relocation, catalina:       "1f912ea47a3af71f4fa9687a05c47b74c8010610d89c921d993e7ec24369f2fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "159507215c3b158719c4ccf802c24b4ecc02e60e2fd9f70e4b08704ad8f49e3f"
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
