class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v9.3.1.tar.gz"
  sha256 "10c4a7dcdaac4aabd7223168a62d393de6b8a3de8f8f0c0d71c39c4e1005e1a3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e857cbc00f667b303be66a23e32e79437245a34b87e283c5ee6f6aa53290c3f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "460b773a445a59cbc4de2364ddc9a937e19b08eac0a0e147cbf569826087968b"
    sha256 cellar: :any_skip_relocation, monterey:       "fb1772aa9db10e67fd58866c8af31dd55abc772b649658be9156dd7d5288e3e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "292b3badf09965f93b3281397d0bbe3dd28472be47e0b957dc4b1620056139c1"
    sha256 cellar: :any_skip_relocation, catalina:       "bc88e10c586e835af3f91ef05d95076842a418d5d39fa9024881e7190b7a9939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20dc14aa3e939e95b8f7489b6d058207f6ad57906646578a855144f091b0e6ef"
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
