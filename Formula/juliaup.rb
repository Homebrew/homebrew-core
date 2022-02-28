class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.5.37.tar.gz"
  sha256 "0ba906ee94b323c9b72bdae27d74039fb0ab3340b33e6d68fda279b72848598d"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "517b7825d92fe098d580a8bb210f00136c58aadaf1609a02253fb09690c2ccf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ffed447029e3890765488af85bc067236751ec787b0248845eb90a8ca4e7ee3"
    sha256 cellar: :any_skip_relocation, monterey:       "ccf6b79af38411aa169c1036b16c4f6223cbb8d3abde1694bc843aa9b630fd66"
    sha256 cellar: :any_skip_relocation, big_sur:        "76151e81ea1214a24e514a3e4594f1f008a38838a3d4c160208f31548223c8cd"
    sha256 cellar: :any_skip_relocation, catalina:       "da1e40d36003cc91367cae76cf9ca5fdc33b087f3872a7d61499f95e08c6a5e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f122fa94aee46925f1ff7b846612fb460e06da588dd43a99028f38bb57a7dc9f"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
