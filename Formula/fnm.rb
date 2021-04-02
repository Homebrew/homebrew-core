class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://fnm.vercel.app"
  url "https://github.com/Schniz/fnm/archive/v1.24.0.tar.gz"
  sha256 "ba03a43748a39d9d96db77d21854e040320617221964e70b8588f63307c5fc8d"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "a57a2ea3b63e05448bb8e1c59771e167f8dda0e5ef87f72acfc9339908276689"
    sha256 cellar: :any_skip_relocation, catalina: "4b4b957337cf19a1a78dbf8e61399a66bd8a89c09a055e8c9bf1829962299752"
    sha256 cellar: :any_skip_relocation, mojave:   "fab982e37191aefce3f86cdaeebad1aa8096a5f93a9fe1f91b8f8d3d5d4be7fb"
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
