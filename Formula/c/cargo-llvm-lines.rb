class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/refs/tags/0.4.44.tar.gz"
  sha256 "43b19bb35fc8cc2eba8cd1904e6ba8d4eb6bbb64722af01f89e74234b79f5045"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "690fc40af096af31a37f387f0dbe1bf12ddb4e72b5105e9bc952d30ba8e9c950"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0004d7c8ac1eda8897277ac68c1c29f401e0b076711c540d48225b5f5b6948d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16d6dff93bfeb3598205e4e2972674518ea26848f3bbb5bb5b0ac0602a1ba9a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "411a895f11a39cd4764abceb89de95f3c8aa7daa51b7044fcf2af0c06074f461"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bd0ede6a26a46032c7885ce8a07028e8da0849ce40696d073d348cbad5fa348"
    sha256 cellar: :any_skip_relocation, ventura:       "42e20c93e33593a79b2aeac50e6c730f071e92a6d13bb6369942c7435f6d2f6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c57759887253e2b829db1f9ef54db3a3fb28e599091f2d9178f636b77d0dfd78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "decd05763b9ee2e329b288c9893f826f6d8372c5334c9d2bf2e288ecdfcb3a1c"
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
