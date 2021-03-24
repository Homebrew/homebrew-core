class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://fnm.vercel.app"
  url "https://github.com/Schniz/fnm/archive/v1.23.2.tar.gz"
  sha256 "ca59e61612c7e9892a1744dfd269884801ce0093708f420b6b321b3a0544bbef"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "ea4ca389979e61b448c07f7276acf32ccec2b1412ab46737198a8a6deb55ee15"
    sha256 cellar: :any_skip_relocation, catalina: "babf2b12fa2f389cf6532bb663aea7926347d2d842e2c66e614f77b1e9e2808c"
    sha256 cellar: :any_skip_relocation, mojave:   "f67bfc665569fb635e0704e4b5e8aff9fde5c94ecf354cee46dcdfcffeae5c9c"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    (bash_completion/"fnm").write Utils.safe_popen_read("#{bin}/fnm", "completions", "--shell=bash")
    (fish_completion/"fnm.fish").write Utils.safe_popen_read("#{bin}/fnm", "completions", "--shell=fish")
    (zsh_completion/"_fnm").write Utils.safe_popen_read("#{bin}/fnm", "completions", "--shell=zsh")
  end

  test do
    system("#{bin}/fnm", "install", "12.0.0")
    assert_match "v12.0.0", shell_output("#{bin}/fnm exec --using=12.0.0 -- node --version")
  end
end
