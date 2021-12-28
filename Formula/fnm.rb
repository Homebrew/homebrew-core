class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/archive/v1.29.1.tar.gz"
  sha256 "87c4c6afee02dc1c97138a6e048382463a03faa116d9381f80a55e67398f8425"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f6ee5ae14fc036bc1989af6d83416c3793e091f63b54c4af462e3409f09cdc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c5620a20e911f6467dfc7b56d0e50ccceecb5be10745c26f305d277253ee706"
    sha256 cellar: :any_skip_relocation, monterey:       "49bedcc76bb5488f235e7304e36ca7d5d364d441d805d9ba983872c5312a74ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "eff23089c17c17df042730f1125174053abfd8d91eac6a2fffe434cc728efc7e"
    sha256 cellar: :any_skip_relocation, catalina:       "0bacd34d125aa95236c003806e70214749c51be3c0c1ef74298d38d8a281aba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab90af7e99ac6bb83bd05de1ac4f0c7cd38dec616b3081979ee4b490986accfd"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    (bash_completion/"fnm").write Utils.safe_popen_read(bin/"fnm", "completions", "--shell=bash")
    (fish_completion/"fnm.fish").write Utils.safe_popen_read(bin/"fnm", "completions", "--shell=fish")
    (zsh_completion/"_fnm").write Utils.safe_popen_read(bin/"fnm", "completions", "--shell=zsh")
  end

  test do
    system bin/"fnm", "install", "12.0.0"
    assert_match "v12.0.0", shell_output("#{bin}/fnm exec --using=12.0.0 -- node --version")
  end
end
