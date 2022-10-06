class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v11.4.0.tar.gz"
  sha256 "2be5396be0f7e804ff36715b1d6a6019014ee066359c28e620d7b61790a130ae"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f98bd90017e2ba074badf63265eb9f305a700b166dc02089740d3fe00244e48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "871817442d1b2fccc0bc0c1d21e532aaca21e17ed506586be1a77e2817d6b5f1"
    sha256 cellar: :any_skip_relocation, monterey:       "f3b883298054f7afff60e1a101f16a28e1e2857e88a82b130a169425fa7052a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab012b7a985351f6ed67ca4736ba3d5fbe381d752c3f3906f325cb89faba16c8"
    sha256 cellar: :any_skip_relocation, catalina:       "f2d924245291c514402081ecec4bfcd3e9931dc0b8ee3f9ea255afd61b2823d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c35f79ef976eacea1fd6b07255b60b0c2b169166244cda6c84590068e4e4aeb"
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
