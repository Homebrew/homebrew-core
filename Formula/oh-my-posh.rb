class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.3.2.tar.gz"
  sha256 "59f54fc50ad89061f52d85472fba35c8305cd6aab66c1f7fb6aea34fd7286ad1"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3774625eb4a09acfe7036fb77dce0cee69c913a8f4b8740326506a4febf755d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77c1f11db30460ef21ca37d9d2541d53837e5630cf85af4bf1728dec4ab9333a"
    sha256 cellar: :any_skip_relocation, monterey:       "9fa7bcb395f1831d3ff954ea46f78dc872cdf7d377a7c096b5d587d40b528900"
    sha256 cellar: :any_skip_relocation, big_sur:        "5dfdd5a135b0915f982cc7ca1d5c35d3e1df73e0743bb191f77f0bc375a8757f"
    sha256 cellar: :any_skip_relocation, catalina:       "95a12dd589a839084357bf801f6e13df81c9f6f0a4cb06fe63e8ff14e9a62a34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "397be71a9a13ecf2a84da49d4191bd9fbf9c4d7f50d2e4d23fd47005a8dc7acb"
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
