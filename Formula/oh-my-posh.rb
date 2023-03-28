class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.19.5.tar.gz"
  sha256 "db343e18a97a0b41800916352c688b5b36345df30fcbcd0b6b3c1d986d393091"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba8520daab8b29cd4b4da42904090111f286cec6d23925270bf9e7c835395e66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da40ec5a647b1960a187047c3dd887a9cd12cb43f4288dd174bf4379aa5d4150"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbadc5175546bcae147809f9da0f6f060cfac468d662cc23660c235c6a128aaf"
    sha256 cellar: :any_skip_relocation, ventura:        "3fbd186db7e6476a7c0d81ad5df29401386f56f4b4540ba89ade7a26a74761ef"
    sha256 cellar: :any_skip_relocation, monterey:       "caa157b401cd72a417976e9be3da257aba1e27fc4fc484a9481f16107306817a"
    sha256 cellar: :any_skip_relocation, big_sur:        "94030e2d73a56aac6c425943ac9da44bfc0543add8e2a26d755327d5d7604a24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddf15e0f08afd26ec364860d54328a77e19ba6c11899f8c8abf317b52268af74"
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
