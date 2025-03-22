class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.17.13.tar.gz"
  sha256 "3ab95ff80688a90790ed70015f82ae13910b5ddeaf4e9f8f77ad8c7d8caba9f7"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99e9aaae64b57a98347c54a87969a0878c9f8a80f44d0a888d74de384df8189c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dec56513766069477ea813f9a189e0711c68c6200c32d8f913beae58cb5d45d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b634b1c81717b7e7ceab75f583ea4e255374236fa7ecb124c588555584cf83f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "65bfe2d8f94b699c62aad98378f55250b403e7762fd6dac5621a97aa230f0561"
    sha256 cellar: :any_skip_relocation, ventura:       "85e1cddc3e02a50b600c2a2ca35c58a82967a3f18b3b31fbef76e96a9f318156"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55080146ecb614cc3a18bada83a4dec691afc5fcac42c1dae1b1aed0303e3071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72b66362aab1212786f10f8e356c43b91574a009c974e59ba11d84ec242f272f"
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
