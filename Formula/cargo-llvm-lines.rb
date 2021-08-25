class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.11.tar.gz"
  sha256 "7bdbabf728b47e6312376bce694429ba397a3c991a8ee1cbf28179442980cca1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2012ba146865a090dc70c62ffcc0dae32d32f9607ac0287fc59fbb704e6bc2e1"
    sha256 cellar: :any_skip_relocation, big_sur:       "7c7bcd775252bb1725b1ecce04d39765daa9eb757ec22517c5471cb2d8c43e8b"
    sha256 cellar: :any_skip_relocation, catalina:      "cf663596ab5fcac259f1fef1f4f194ac85ad4b081fb50c599889b66a6cde145d"
    sha256 cellar: :any_skip_relocation, mojave:        "280deac6629170aa055343f722d51d5d0b5114c8222e8fd32e4bdebe8f5b140b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4a1b487955d0139aa7b8952bec9641ebe49825a99b8b093b98465cf475b220f"
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("cargo llvm-lines 2>&1")
      assert_match "core::ops::function::FnOnce::call_once", output
    end
  end
end
