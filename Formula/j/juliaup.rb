class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.17.11.tar.gz"
  sha256 "2b3b88695b3cce2b79e70cabf2291f70306729baee6a939eb160b60449030e67"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5203fbc3947cf9dfd188af392e8bbbb3ce43ee9a0f518925487b175b111b488"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e035104ebcfcbc9133f9f14bbae233e58593ff224f0fb04c9eb278b18198c7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cac28112a2900d24132171942e1c1886885a507f522c1812de5d474895142e90"
    sha256 cellar: :any_skip_relocation, sonoma:        "7398cf7f95609400c3b70396e93791532c664b9ec6f7d1b7818c0820c2bb5668"
    sha256 cellar: :any_skip_relocation, ventura:       "f1cbcfd01b6f52a5ff3d4cf5c01e9542ea3369efcc09f13d268bc487de0ae8b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4419628abe75e379b81192e647b7922dcb703b59dece92f9acb1d821c5508425"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", "--features", "binjulialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
