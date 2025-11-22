class Bender < Formula
  desc "Dependency management tool for hardware projects"
  homepage "https://github.com/pulp-platform/bender"
  url "https://github.com/pulp-platform/bender/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "7a7680406c3119848c5c3c2da54d5eca9639f1ec36d47784375f7464a0289b01"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/pulp-platform/bender.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6ed5dcc8c2da221365670f0b3fc99a96fa80444c13bdb70ddd3e14ba8a5998e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d528a998f05d1d674ef20b44bb903e5fd03cc41fa742346dd55f7f67ae9bf7b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c901cc63c62ae8f68c3712bf036fab5d7425bb951dfa95978812ba00bf80881d"
    sha256 cellar: :any_skip_relocation, sonoma:        "72b1eff21dea97ae6e7fdebe74bbfd55823059fb6c7f39b0b2d9fa3805bd0532"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15ac2361ed81793d04408bd47ede5eaeca091c568df2f3b3b77212948bc0ff55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69b90257c68b0b351de2870abac81a496401734dc17a1873018ae9f5ed740f03"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"bender", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bender --version")

    system bin/"bender", "init"
    assert_match "manifest format `Bender.yml`", (testpath/"Bender.yml").read
  end
end
