class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/refs/tags/0.4.48.tar.gz"
  sha256 "7eb44a0296047711a9c2c301296ba2c4968203c8fde65f8405de577dfd7c5107"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "906520a5b5f770cbd8ea9263473f04c0492a7bd5a724dfe2fbe1e645d6063981"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bc97862430d9ed5dac448be41a0660acc9f3ad28277fa05af1cf53932a0fb8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fc80fbd3a2d76dc9a38a4a469865bd5d3c9b4d75bc0af28d87d9868ca45eea1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f57774a8e70ddccfedb77b50d1f96f8a60e3e1bd0d355132ed2688d6a55134d0"
    sha256 cellar: :any,                 arm64_linux:   "f0a3d784a4cd78a01c0953da13b1b93795466a600581a015046831d7888d5d11"
    sha256 cellar: :any,                 x86_64_linux:  "0b7838f8ce4fd9df54ccc5d2ff574fd3609218c85408478d1b4e9cf9223de044"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("cargo llvm-lines 2>&1")
      assert_match(/core\[\h{16}\]::ops::function::FnOnce<\(\)>>::call_once/, output)
    end
  end
end
