class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.6.3.tar.gz"
  sha256 "11da203c7f037a3850e6bc156d098de30dd82a98f2fea72ef3e86238ff45e0db"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5a28296af403db846425833505e38d3cbc5f200a89ea8160d6c45e972d49dcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b85e3399d930bb56094fab02ce8c302a358cf6d4c04dff8a82aac42352fdecb"
    sha256 cellar: :any_skip_relocation, monterey:       "69b2619cd71895235da692531de63010ebddee77961a6545eaa7d8cc476459ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "28d7a5258814c20dfdb9215f7dad7aa91422bba23d5a23e068efaaa518e8c3cf"
    sha256 cellar: :any_skip_relocation, catalina:       "4333f27bf8ecab74a1220dbd3865f5f61dfb904865da60815c93c2185ade68de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab3a8169fd0aa38c65cf572a3f5779883dd60b5ecca4d3d405e29b76ba8b965b"
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
