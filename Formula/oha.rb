class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "4d76e08b9094e5f83c42f4c322b1fb5bade2aa34aad1d4717122dd395eb8db89"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dea2337ca5e2a509ba8ad3b99f62c351a06f2e0f5375ed90de51aebda0bfa8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a9d722fd579ce96c4bfa3fa9a2db65802b865a55a87c707f86b0b1b4a97698e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5477596d1003b0f15bff73404810039f90c85250eac7dcfdb77a4b33af251f5"
    sha256 cellar: :any_skip_relocation, ventura:        "a15391b1c0276a347c073779797a59673c8d1ef9d4630805bb8bd962c912f54e"
    sha256 cellar: :any_skip_relocation, monterey:       "3dd0ed783ff5d4890d55a13d54ec5b3b5626684f976ece6e6eae1b9870addb22"
    sha256 cellar: :any_skip_relocation, big_sur:        "eae34bc3ca152f49ceb468e60ddfa215cbba511054e7c2783c321d46535cb93c"
    sha256 cellar: :any_skip_relocation, catalina:       "d26a9bdd54ef059691f2ee3284b415d50ac39c52909e3942815339dec3f81457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03281c9e56ab7ff2ac87079330e191c0de928e6faa5a96193ee18a45a261b39e"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
