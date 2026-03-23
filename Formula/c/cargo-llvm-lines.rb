class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/refs/tags/0.4.45.tar.gz"
  sha256 "d1e6fb07760239c2f7ee1ee7e7a857ffb4f82df1378bbd0e4d2e8d75e74f13eb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f96bc5657cec596d1c8345a7b33c2b8eb0dcb5e80e677b8c1bcc55ee7153f05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b003e01713c2c21b2ded471c1617b74d349574847e4ec18b9040e5aac73e5ddb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78435265c11559ef3470087d97d951ff12c1fa29590c1f485daf1fedf186001b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6710eaf6730d103df0bbddd44ff1b71b80dd1c69590798d5a325d71f97cafa1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93bbb22430a1d3b4dd16d55a5ce5759a370b973cc8272aa528ae80881acedf89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b83bd2492130d970f7488f4c2ae35852e026a01a79f1668d52704a7977f4dc01"
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
      assert_match "core::ops::function::FnOnce::call_once", output
    end
  end
end
