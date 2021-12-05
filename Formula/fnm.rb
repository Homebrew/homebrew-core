class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/archive/v1.28.2.tar.gz"
  sha256 "02bec72f9978fc2fd7b2671b25cc2bb019a64c0f2d2fe7ab72ec0add91288599"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4273be0f2ab48b12c3b8a0f0319e626f331c73dd77ff0837606a75ad6d249785"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b2b531986bf715a1db9bf2aaca5d3369a8142fcb5355747b565cdc284b79775"
    sha256 cellar: :any_skip_relocation, monterey:       "1eab89a9dc5836b60f776024c58c41deca893698941f30b0550bce08bde01a95"
    sha256 cellar: :any_skip_relocation, big_sur:        "9aed41c0cdeefe733b4b72d43076e646fa9ab51dd929c72176622ae9b19e00ec"
    sha256 cellar: :any_skip_relocation, catalina:       "0240c8cabbc2091ee43c393444c18bdaf86b73a872a6fb126e93fea1014de76e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "542989dce8d797165b4f6c15faae6b7085a6e27548282a51a56c80d43203cd9e"
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
