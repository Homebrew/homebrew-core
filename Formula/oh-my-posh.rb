class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.3.1.tar.gz"
  sha256 "97307ca0834223ec88852244f67f74082541190ed0b45c254d4bcf98cc8c2346"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bba17ce779c4eedbfdcdfc9e40c3ebbb1f2116ba12f969719930c3251547abfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cbd7986e6948b5ecab85b2014249cd5e517072efa43b46bcda0edd52ca008f3"
    sha256 cellar: :any_skip_relocation, monterey:       "cf572d55b5bd17da25eb62d470049b67fc5d4dce5d2b44257250ab2d9075bd31"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8ebc864002f47ebbbdfbc8615c824efbd522663e59594fc701cf20c71e8579d"
    sha256 cellar: :any_skip_relocation, catalina:       "0ed594a41ec3523610213c95c07d78082916a0dd4a94c66df9c885f242ab840b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "031d2399c06c572df190cf7f7961c5a37fead0f7baab816ae75ec67e187120f3"
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
