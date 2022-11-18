class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.16.0.tar.gz"
  sha256 "3c1fa9bb1903079584432b20d4d34238957f8fa7e84ba56d05bcb15b864f074f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc36b2d28061cf221fea0a99fe9b7bea6faab3c5dffea896b24c5af4307b4d57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad5db911a49c7232df82da8e1769f9441e9e98631b690b576925d9a4350cb0b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f30f1c26d4f42c40daa08f22b2ad1775c37b8fc38edc0de52ba6a8543f1a36a1"
    sha256 cellar: :any_skip_relocation, ventura:        "2cbc8e2e3b86d3c9d4cf26755bebcbff4d24a34d93ba1c249fa885243cc9666f"
    sha256 cellar: :any_skip_relocation, monterey:       "054d3e230b91cf22e4fbd33b659f8b9780df427a6355de528a59f1795f23c124"
    sha256 cellar: :any_skip_relocation, big_sur:        "18d180d81bce536c4cad1e3a96a484a9c3bd086c0037b3e23d964fa14ec78a02"
    sha256 cellar: :any_skip_relocation, catalina:       "737ce6c33ac9100197872a5db9f5ed65def324cd8f8a967d084437a2cf4b5745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b628e5d5a3fe3db0f47417e9c51fe78edbe35cdde9ca96e874bc72c5cfc016c2"
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
