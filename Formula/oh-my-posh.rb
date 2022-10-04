class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v11.3.1.tar.gz"
  sha256 "f3001141008f4a7e09a264e110f9cf4a59aac0aeea911b56471d5f686cdfd495"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aa075a5241fbae90b4d31d001432ece0a8f3f92e25a5d9c4a8b092ff96b3cd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a751831bdd474a162a6599ba1353aec36f95375d59e96a263807147db8dd59db"
    sha256 cellar: :any_skip_relocation, monterey:       "a863919276b2c9e4d4e931a04e026484d747a9c07c681da2167bd682f59d28c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e71a96374eb2db6cace3e0d14a81acd0e3fd7f72e050d933f37b47361cde42e5"
    sha256 cellar: :any_skip_relocation, catalina:       "d00389a51e31bcc6abb3eaa6e66e42dff6f2b747de4eaeb37c2ab4e18076007a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b916188f22191cd7437efb5a4f75e8e666d3c91da75213c34ea66b9374364386"
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
