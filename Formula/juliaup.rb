class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.7.20.tar.gz"
  sha256 "f1a6d56a91a31064f6d49eab73cb209caa38d034f9f5af32faf19e829cca44ed"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d120f78f39dee79b0f9375ee34f0eebdc94d4b3496a558121f4516fa4b115a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbd1ea5b5a4c02f1525b3e11ea56dac6a72a24a0e17c1ba3e70aa9a813bd2025"
    sha256 cellar: :any_skip_relocation, monterey:       "395bc1cc7f2b217e85c18b997bd8260525cc49197ab4ce5bbb1c03fe371e9d8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "09de91ad83037866e4eae55fbd4bb454a7c879663d1f1dc7abe8e12a6d9c041e"
    sha256 cellar: :any_skip_relocation, catalina:       "e063f5c107db887474401170329e641920502fb467407b2e11132bb0030ba66b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92fe76ba41e304f7eb387731487e00612441ae1dda25d5923c93ae6932415e41"
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
