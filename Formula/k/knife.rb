class Knife < Formula
  desc "Reverse engineering toolkit for PE, ELF, and Mach-O binaries"
  homepage "https://github.com/bl4ckr0ss3/knife"
  url "https://github.com/bl4ckr0ss3/knife/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "822e3f48a8d7986d0ae17bd47be183884ca414195ead205823d0825d826d6062"
  license "MIT"
  head "https://github.com/bl4ckr0ss3/knife.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "591acaaca4bb7a9427cdc7b745dc45e7961399432dc2fdd90caa2f3d274bca87"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d83fd2671419ccf0ac7b09a9d981cab4579e1115b427b112aa6846dcbb9cae01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7983e958dedcde1f839064019c32f511e745bd527f9944b275c4552d5970383f"
    sha256 cellar: :any,                 arm64_linux:       "85add277b4a471e4bf9e2c2a36a3ca0778640ad9e0ee2fd7b6dd195829cca5b5"
    sha256 cellar: :any,                 x86_64_linux:      "e9e5902650c4f357a1f7d525282150eaadcce9b94c5aafceca2af467f186f8e8"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"knife", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/knife --version")

    (testpath/"sample.bin").binwrite("\x00Homebrew sandbox test\x00")
    output = shell_output("#{bin}/knife strings --json #{testpath}/sample.bin")
    assert_equal ["Homebrew sandbox test"], JSON.parse(output)
  end
end
