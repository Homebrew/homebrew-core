class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.6.21.crate"
  sha256 "42236fed339535379c8671218bd8050ddf2b937cb16f6012b44b6cf993ce7c9c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7d8f20b13a4794ec223122f6bf339ebd6bd1be2e3601f054fa06e7c2f8a5d32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "182be3be7cfb80a0f3ceaa1b0eb300f7a508881925a24ba3e597feb055b79911"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64247f6a0db86435db9b5250006e9e9588d6e68ef861744505ec8313b241bc1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3534abe44582f9c53641e8a19bdeed554637ea36cf0806884cc8015a5cefffd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dad38bb25d4613a1965ef2d0d91f49f6536f90f553664553200c90f2cf7ab5e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c825d5543c26c470dfff85bf8d3db1c92c8c3973c7938a6e06710a29518e5cc0"
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
