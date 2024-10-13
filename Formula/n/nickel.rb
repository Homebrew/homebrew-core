class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/1.8.1.tar.gz"
  sha256 "85cd1b42fdd41b5ff292631420467b86e94abce5edf80f033a02cc2629b8c766"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d01e228c64ee786f1c2074f1ec4e07684c6cf3adb808ed93f4a78d9b1adf790"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "769c5b5c6ac783519079ac730458e7ed249f341590358b4d1485c7fa85e3ca8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00e45a6b8f2f81191871cf9bde82baf13ba9b96423fb1ccd23059d865681f6ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "f89dc2ca972a95c972724d1aad4cbeb3e28d751063e3c4c36364340b2780cff4"
    sha256 cellar: :any_skip_relocation, ventura:       "3fd015602b876e04c369ca30c31d3918c9bbc8533a4532ea685c7d30e6d60b35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ff2ba9cdebadd6b542413a5e5a0ea6f97a7b79c9a41cef538f67e7d806a1729"
  end

  depends_on "rust" => :build

  def install
    ENV["NICKEL_NIX_BUILD_REV"] = tap.user.to_s

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"nickel", "gen-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nickel --version")

    (testpath/"program.ncl").write <<~EOS
      let s = "world" in "Hello, " ++ s
    EOS

    output = shell_output("#{bin}/nickel eval program.ncl")
    assert_match "Hello, world", output
  end
end
