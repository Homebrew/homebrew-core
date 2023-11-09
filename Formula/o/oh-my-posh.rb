class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.24.0.tar.gz"
  sha256 "95db0e3d80c9c5e7c12810ebf1e9b807a11eaec98f0e00f75f48940f7b90491a"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1601d1c5ddd32e03dd859af09d3455e86c5f643e67adf0f241b79117b1c96f3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81260686160c221469da94db9111ceaca213658fdb4e0081747e4f489435b59d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6989783d8a9be0e697dd6b71c89947f665f25220dbc802d7f620e17c5bbf915a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c605c54e9ed37bcf860d3a392c12fea050fcf5acf52a3c42db88cb15dbbac33d"
    sha256 cellar: :any_skip_relocation, ventura:        "ed70b05bc7970e46f4debe1e323510a08ae1baf01b9f11da8a05efe0bbb88e13"
    sha256 cellar: :any_skip_relocation, monterey:       "c1ed7d2d4d2829e5d2f6048f3a4602468555dbce5d666f931a8c1377cbdfc2cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "394c204ce1e9d03656214f01822b9615df01bcf13717e7dcc590f46d3df51e6f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
