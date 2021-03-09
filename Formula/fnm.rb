class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://fnm.vercel.app"
  url "https://github.com/Schniz/fnm/archive/v1.23.0.tar.gz"
  sha256 "778221f7309c03d74ed7aac2c6e552e325ab2a85e536029afa8b27d2fa5a22f1"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "860489c81dc4ddb0c58224b7abbc153ed089c80d10f81da49b25be42f2ebc9d7"
    sha256 cellar: :any_skip_relocation, catalina: "d122db71fb25fe186a5f75532664e2589401354603addd9fa1a1752799b51d41"
    sha256 cellar: :any_skip_relocation, mojave:   "1c81c7534c4f5ffa5a228aff560794f8b8573301650a071764ae2d563ce22b91"
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
