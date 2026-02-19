class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.19.8.tar.gz"
  sha256 "3c33179c8de15f2090e817f5a492f069dd0c5bc548d2ad31faa9717f3eefe683"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "281655e393fd0c72e74aa0d0f71943a61b2bc4a2a7df71273c6bb7cdf4337923"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "315ca6c999d773b05bfc4be7008383f5bd8b8f511d801aad8f1b6848430d13a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "338fabb6c636dcdb3c38b53db0132cd41689a4ffdcb7ae3fc0d57985499d68c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b78473872a2ce3715ae580dd184908246233c5964fdd55ad87e430e05d931199"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffee395183d0b0f18ab43f4f297f88ae4d7e3cee756e2bba889bb08339859924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aab52f9b27d23c4798543b7f381f062b36379cea1950dc61dd8c27119de0639c"
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
