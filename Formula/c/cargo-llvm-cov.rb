class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.8.5.crate"
  sha256 "e40b72db9c18b7e128730f67135c065d73d014c34d59e107351b98214eca1034"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5d430963335d26b83826b5428326c96c9d5d57d2cf05a439b3bcb05a3d58af9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61bdae477ef4a58bdb497e2d330eaba6ee21c74b7927356351c02adb553cbfe2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc0d126217fea5bee098d3bd686c3ff6558200f5c99f0d9a3a335bb941cff021"
    sha256 cellar: :any_skip_relocation, sonoma:        "c471f93c229cef22c2a23e2adc17f9ed1d4ee92819e2fd1a8075b172e70874fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f323bc5be03f8668ea64141bda282fec2362534ee4d0c8546d1297cf091e6744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e319225916b12d4b61d349c6e2384437e85679fceb3117a70026faa8e1c5211f"
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
