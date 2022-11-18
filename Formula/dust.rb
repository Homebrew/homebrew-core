class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.8.3.tar.gz"
  sha256 "1e07203546274276503a4510adcf5dc6eacd5d1e20604fcd55a353b3b63c1213"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffa6dcff87e28671bcb9d488a54e2b095d78ede9945a736b692f1f03d6e4a1d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8459366edac296e35df8598fa1ded08448b691ab07de289d3ad02ab403644ac0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13c912d4ca38e5fb053a02bb3534df155125f662a1a5554e4def555b74d0c5e4"
    sha256 cellar: :any_skip_relocation, ventura:        "751b82c8a0d41f9e8dcbe91b4fad1e08727a7d958078961058ea94841873e676"
    sha256 cellar: :any_skip_relocation, monterey:       "6a04c6681d1cfb6357605d018be6fc8cf20fe29b9da656a5886a5893585a6c9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fb7f67c5612d8172e34e019af005c267119ca1caa2bb2cc1fd2116aef182c39"
    sha256 cellar: :any_skip_relocation, catalina:       "0e3b7c9209a8111e83f97ed92e8f41c220564558d032e7a918017075e57d68c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15f9df74f891f4087e40a24dc38f3d5a5aecb6ff0caae2555585c18e5fdc065b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/dust.bash"
    fish_completion.install "completions/dust.fish"
    zsh_completion.install "completions/_dust"
  end

  test do
    assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
  end
end
