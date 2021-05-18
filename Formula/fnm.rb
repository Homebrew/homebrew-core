class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://fnm.vercel.app"
  url "https://github.com/Schniz/fnm/archive/v1.25.0.tar.gz"
  sha256 "c1ea037eea02dcea1f05b8a6fa7b8b612d52b3fabbac22f197d15ece51267396"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "355c9b0648fa069de156d4abf097f699a84e954642d5dd8938fbc47334f002b6"
    sha256 cellar: :any_skip_relocation, big_sur:       "3e72c6b836f28fc9d58c2caf9ddbc7fa04aa363c7752cf9cf567d689729ca5e8"
    sha256 cellar: :any_skip_relocation, catalina:      "f3acabfa84fdbef92d68703fcb12a6120f334bfd69c684d576a8e0ac30f45d37"
    sha256 cellar: :any_skip_relocation, mojave:        "d4567300fc34c94ff65e20449a0bcde63ee069aa6d234f1160ffa88bd896e2ad"
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
