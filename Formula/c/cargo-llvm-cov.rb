class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.6.17.crate"
  sha256 "5d99e575343630676845541dad8d99b46706b58df7438c1b1297a5472faf6ce4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d79004d1b3066538087fb0b055d54f03700dfbed923d55c80899a24d7d12524a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f2013d2830eaedb2a69dc506d0c63db29fffbe9f1437058d20475e23cf5339c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b11a840743e59c9b8619afe5162d5df673f9994fec26a489d25cc9d75c71d265"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef5b72e9dede52426b266a385aee63f31b81548c9d52015efa55746ba96bdeff"
    sha256 cellar: :any_skip_relocation, ventura:       "cbe9f70c9a83c4386b348561306534cc2304da9e354dab66292ceb5f6b385344"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60e07078ea3dd08c11248d35112985e66684d3c07a46a636af63c45b9982c896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecd5ec74624ecbd1ecb0f6a68da203ee46a063e0368edd525ca9f5e6cfa6654b"
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
