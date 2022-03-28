class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.6.0.tar.gz"
  sha256 "b8b0802171db772ee98aba8ab6e916f7c77f450041fc78b0557e851dc45ca9e4"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cab8b0c215041423abf859dfbe3c249c24824cfdace22b1ab37669bba367282"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d03d41c94153705da1a3dbe7417222278ba17366fb9f02869d3a7c85f929d819"
    sha256 cellar: :any_skip_relocation, monterey:       "4259b89e20f3e515b6a0bbfc8386ab9c958b6007fbbea6d8060e5dff1dc1d6e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a4a590f411e3e9b5aafc8ae3b46b7856125b4cd92424c136224c3573e634311"
    sha256 cellar: :any_skip_relocation, catalina:       "2acb3d0e5c29b7a98b487e1fe96b41d4cc0aca73274ee851e1af5d980801c13b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "370922e0b40f24ef00ec42f7bea8b0d2f5c2580e79f964425ee04a7b0ecc5de9"
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
