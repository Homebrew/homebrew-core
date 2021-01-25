class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://fnm.vercel.app"
  url "https://github.com/Schniz/fnm/archive/v1.22.9.tar.gz"
  sha256 "02626f258c4ed57ea60891c2374eb970635ce755b8c5ef22f2076e22840d90cf"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9f073ff51580b262d00216ad4e507c6a4236137e0f625a24bacefbd2f29dad8b" => :big_sur
    sha256 "e7ed8b7cee22c502179a0ac8754821eb396a397866c8da3e875343676f7c2e9f" => :catalina
    sha256 "f764e8d198451d5e4311830d52b16fa3cdd6f2b2fd4ee459991fab7642c94a84" => :mojave
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
