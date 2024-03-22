class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.14.7.tar.gz"
  sha256 "8fda7c7af09543f67279e5ccbb7939ca61e0d1a9846cb366c3a435e03abb8b1b"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdf000e8d911a86d6274ac0b92880016f7e01a358793ea5fd3cc5e71a13d7a45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54d8e2f280353ee7a4cbb3e15714996a183e4bfe66e5b129779f6d0becf8c561"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c2871238e1210f3195d7153dbf7421c44a4b21d19a95a80e50c069aedbfda26"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e076f25ed02241dcb7573caaf59dccf8886330f9b32026ed9b1abf469bca75f"
    sha256 cellar: :any_skip_relocation, ventura:        "399896bd8c1075f6b15ff76307b5b1dae5f5a612583ebf295e06096da240ac59"
    sha256 cellar: :any_skip_relocation, monterey:       "01c8c28c4d078266cf2fbbcdeb5ef6248c2e277c9bd68888a6753de8fc6e6785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3be6337621764a1485f32f970dec18b83e342a158755df5f79e48e0b4cdeb5fa"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", "--features", "binjulialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
