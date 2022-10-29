class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.10.0.tar.gz"
  sha256 "4f80b5624d96382417dfba92b61892ea4fcdfd2f8b1e17706375dce6cb2fe872"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40b81e42f12b66f560053d2e9099e99e0a85c0fb4eea6266e4f553d5158a8658"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd6288549a4f1dbd6d888da867127758d17188c4498196659565c9bd6a8efeed"
    sha256 cellar: :any_skip_relocation, monterey:       "53c5f5d1d66eda7e601e97964701acac74290127dec346e696f91290b5be447c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d512fa30818f71821137f7bf986402b2b3cd0a708cee52a30feb3b79abefdf10"
    sha256 cellar: :any_skip_relocation, catalina:       "61e97363474df3a1f61eb1a55a0057becc56a0f94c05da6bf7d167a8b8ec7bab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8497a4671a745e429953f7f2253ac6336b823764bf229aecaddb449a8352df8"
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
