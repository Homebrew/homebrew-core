class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://fnm.vercel.app"
  url "https://github.com/Schniz/fnm/archive/v1.22.7.tar.gz"
  sha256 "9ca011ff4d18a5c61eed2752d0dcead00c37b152874559e1c080a722f5b3e856"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git"

  livecheck do
    url "https://github.com/Schniz/fnm/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5ef8aa4e9d807115fb9d07a574f9310e54ea5424e348398cb777948cd967a3b4" => :catalina
    sha256 "1d68be19c87276cc3f43f6a9dca925c366752e57673924667311116e3d27277b" => :mojave
    sha256 "b20020182942c4d16b205058ece8b5508f2f948a6bd5f785e2f91843a0df1a61" => :high_sierra
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
