class Committy < Formula
  desc "Generate clear, concise, and structured commit messages effortlessly !"
  homepage "https://github.com/martient/committy"
  url "https://github.com/martient/committy/archive/refs/tags/v1.1.12.tar.gz"
  sha256 "0e0f6d1a45b0058404cd2dca505194492c61e4b3b4521eb12be5a8b2bf93b585"
  license "Apache-2.0"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"committy", "--help"
  end
end
