class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://fnm.vercel.app"
  url "https://github.com/Schniz/fnm/archive/v1.26.0.tar.gz"
  sha256 "fedb9745d6c82fa6e0593856b1b995b286782f52f3497861839c6ee46559c881"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f222bc246bb34b6e6b01287cbdcb52f78fd1cf9c0220ca79e0db2307c84cd8ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "ef6680b7f1c89f9864e8fbbb7ceed6dac81d237ddf001f4808200a2524c3e005"
    sha256 cellar: :any_skip_relocation, catalina:      "3e6d64efd270f7d081de052f6380ded8a1ebb436cba26fbb41d1a32098652f5b"
    sha256 cellar: :any_skip_relocation, mojave:        "ce025c6632c739424486532bcd3c460571366e9933392b31d153bc5a8084eae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75b4b360ff4565c3a6ceed6381373702b3cec7b842d5170fe6d39b57116618d5"
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
