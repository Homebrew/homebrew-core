class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.6.19.crate"
  sha256 "ca044600789e221bf1a9b3c75d3c2b616f542f895513e960f1533d569ee92f6b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d7a09b7598b0086958118d492e1ae2cff1f52cd03b127c2ea4c669b59175880"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f18730e1aab71a15c206e8cfbcf6679961325a009814aff36825bdfe2a363ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7df2a4b918695d307840ee8e1189a9f3f1df57c661f29aa4e44ea126b4a69f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "598d646215b0c46e8905ffb583ade2e154f378375730f3e1148a582582d3cebe"
    sha256 cellar: :any_skip_relocation, sonoma:        "f086e991a8d692c71d2c3d4e885aa793df81e1d6544cc750d9ad6b32bac526b3"
    sha256 cellar: :any_skip_relocation, ventura:       "3fb06b74701e36bf876134cd1cbc7d295d0756c9b9dc10b70ae6aba4911d3d2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9550438d5569c1b61f0134096fe05038040b8fbc2d26b2f9e2428586320f81b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d55c68f475d5d5c053b98e16ec6dae103593bbf3e58ed7c30e92b262282377f"
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
