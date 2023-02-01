class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.0.2.tar.gz"
  sha256 "b2c770903356ccacacc94b7a3bf616723efc4c24085259f77c3088dbf8ffbad4"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e64fcf239390a7cbd9b642ce8ed3d6023cb196814e63c5222bbf457f75fdc4a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "483da835116874d6fcd874b1c17582954bd07d4fac0e4c03c68bbb30a36be6c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccd298fb4dda3d8445c596e783276b41b7d8266fa5f4470d0658f178a046bf17"
    sha256 cellar: :any_skip_relocation, ventura:        "53fa70a6c4272392d93ee81e3f42a4ecca31ca4a5441296db9f34eb4073f7f4f"
    sha256 cellar: :any_skip_relocation, monterey:       "510760091e943c5bf8221846b2e41f483eeea1158a5d2f79d1033a980aa7a826"
    sha256 cellar: :any_skip_relocation, big_sur:        "e36ba630ac227e64e40fbaa0a904a4e2843b43e15ff48fd5c649deb549d64bc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "776a08576b005c644dec51a10bd8b900648deaf4f5e034762301fa04e4dba95d"
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
