class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.36.0.tar.gz"
  sha256 "b4721bc024e6e9eebaa9a4df9448a296175afb5d67e19d1d2e332b9bbb0fa186"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7613d16664751cc4775e973b426cf2bc9b5a09650bfa3850b7ac0355d114318e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "899839237584c30311061c8714812412809b0a4049d881781362d6b8b95e0b46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb24447317d4782e3bfa211c107993b216b9305e6e7e596ea91a257b360fee45"
    sha256 cellar: :any_skip_relocation, ventura:        "fc0cd9cbc2825160abaeeb146ae57fdf7088b08bd6dfa392df6dd92085376fca"
    sha256 cellar: :any_skip_relocation, monterey:       "f52158b1a0d85778db913b0546f009169b521c88c73f6cf166395163cf6464f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3b4a580119ba4a7a46b1f8337ace31ff0fb72eba90066a629442a503daee91a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9dbf892bf33ba71db02c694be45188f21c3806ef1f4c5519202575b075a1d06"
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
