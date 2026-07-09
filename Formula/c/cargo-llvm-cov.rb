class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.8.7.crate"
  sha256 "dbb60793c145d8ef09b5cfa49c2f2890b93bde5a13885a9369654ca87dddfe7f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3f109f463caad49212d782e423961da95373bf3e6d27bfff3e4a2974062bada"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d32145a46bf477fc3b36a761910617cf56a0c5a98c65e6e4e3c63cff20917297"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a67fc89dca22b171296f9e77acd6991ca624d51e039205949d05957c47dcdd90"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b0ac025f1f139684a441d20f5c1a6dd0112f823fd0169dd7681c8f0de4d71de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eec9c4289a06b3e1f4176186c139b4e564a994109bf4e7a645fbd739e91d289a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acbd628b30fd01a87f8cc7af6535d304ea20863063967cf89aa2ca8728f73744"
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
