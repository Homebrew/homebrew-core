class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.10.1.tar.gz"
  sha256 "b90243f33afb574ac1bfc92ddfc21098f7f571a48ac275bc7db40c6111546b54"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7bb02184ef2ed74f0d92b71c16de091b806de5933ae7d8509bfcb8a9156db1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27958f7a1da20360f65fb7ffd52ce67f94b1da990763763b0549bc933d13c5e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "280e9a04e9d18b0b8cd5d2f3013d9ba92108ffe82e9eadf72de81fb8f1ecde05"
    sha256 cellar: :any_skip_relocation, ventura:        "580f3b4ac78cd5d8d06edc28855685207b03bdf24049c0d7e1572bfc6a927051"
    sha256 cellar: :any_skip_relocation, monterey:       "1247f0ff19b915864b9e3f9ac73cc369ed17c594d156cc3ced58881b702ae333"
    sha256 cellar: :any_skip_relocation, big_sur:        "0996b4b21a985d4c832d061a94d3e0669c5d6405ec940acb15e0d6c7239a2ee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af6e969f4bf21e8783aa110d6ba02a4df227fdf77d93bef9e6e32a5726fe039e"
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
