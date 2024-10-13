class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/refs/tags/0.4.40.tar.gz"
  sha256 "70596ef2743b4ee77a1649a10ddb0b75e4c16d96cd50f57839dbac1c240a142f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b109db417b56fd0d331f38d1ac2abcde76a8634a28870e500c6960ebceced3d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c405e2931b80f437e221471174150be8f9ccde85eae0ab03ff9ffbd55c5b7213"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "732122c582f7275a2c57786204890fb0238866f27e6b57aad687df5b264566c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cad1d52ae63818e59c708ae3b796acd07958f1dafb233122db95dddcff43eea"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b5472c92564fc40ca099d47b0294108840be0246cc118c092a1bfc8fc8f4951"
    sha256 cellar: :any_skip_relocation, ventura:        "2a8e3322e4a5d92cf2cced7ee6f3e2548dbf7e5e4554e697e6c22f55e8759d0a"
    sha256 cellar: :any_skip_relocation, monterey:       "5bc5f7bd28a35a47be00b628620c660d45d2168da560389e8b69a8b47af641c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "007450da409a7676018c6c087f07adf52300bd7f6bd76c6a7bee73d5151387cc"
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
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("cargo llvm-lines 2>&1")
      assert_match "core::ops::function::FnOnce::call_once", output
    end
  end
end
