class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v13.3.1.tar.gz"
  sha256 "c653c65fdc12fb65d855b24ea88393ef291f2927973f824f6d8b00754d7713b6"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f91b9e453ff68445f390eb83874977476cc829be51233282933ccabcfdc6d2b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a7fe54aad7fcb4c10b592106554c973b2ab7ca1ff70405d721a62eaf174f387"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ff7d321c8a18e6f2790a8a45103eed408d6287a256651d9d9c35a88d26bf22d"
    sha256 cellar: :any_skip_relocation, ventura:        "c7c90392a8e1168d5a1599008accad86fcc8c21b48f23975a73761c45b98ec4d"
    sha256 cellar: :any_skip_relocation, monterey:       "2d6e4b2b24a718d5f1aa4741b79d9870b88451b0b7528c97585fd43d616c99aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca9ade69fabff71c2f079dced76ae61e272b6775b4dc240186b3007a5bdf0254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd1d7898a2fb0b362887abbc76f96e1c5f4b46d3a7cbac63811af4eae9fcae73"
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
