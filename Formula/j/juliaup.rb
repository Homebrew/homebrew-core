class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.17.9.tar.gz"
  sha256 "3072a404573e0e64a7d586f32ac1ba5fcbacd142e2050f7a3b452d1697181f4f"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e84ee721d94f7787b4ea8c3ce77752830711e94b13f87842d4dfd27138f3fd43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd11b877d77f82c7beb5fb102e1e8f3a3715fe568a2699010c1bcaad3d2b46b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "864e83c4ff6de21ead0b3346e54eec588c6663d8855a888a1b1542ff758c6f6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "06e8e226914a53b69d37fe0723c023c5efad70419fa442e3951ca52a3ca5fdf1"
    sha256 cellar: :any_skip_relocation, ventura:       "d43507c389fbd224e03a5a1fe89afa21780b83877fd1c957bfde2aa261d6c102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17e94e36ca27e33f9473b0014de9cfba5bb1803ed3abd77ac6c6d21240296bb8"
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
