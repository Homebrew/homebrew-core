class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.6.16.crate"
  sha256 "c33091bb8baaf21eb24807559ece8ee6d4a37ef42509958d863b66f53557fc73"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a465bc46685f523216eb07b016a5d2cdc8c8cc357a23a49d0b716b1818187a0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0a286c1ff4770c00bd44b784248bfed632e2518841afccb3608d8a1d179dcc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0046a18ff5aae5d7d9ec91991dfeb17072299c46d57b0f367101f6a624243a6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c50bed8fc9bb29e7f3689089da9b5cb567f924b4e4a815d06eebd7894dba8869"
    sha256 cellar: :any_skip_relocation, ventura:       "c0bce3c5bd2ead0aa124ae024895518f57e2ced449268a8a7ac17a1c578fcc30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9926751cadacb34fb6bfdcb5cd3cf23570ae579255df7b7a3a0fa5b638dc8708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a111d607f6169e0411b85f6646b6259b1f7e3d32448c1b9753e5d26308b1d3e3"
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

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      system "cargo", "llvm-cov", "--html"
    end
    assert_path_exists testpath/"hello_world/target/llvm-cov/html/index.html"
  end
end
