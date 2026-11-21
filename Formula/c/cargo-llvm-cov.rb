class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.9.2.crate"
  sha256 "079b7461474a8fc030a9f7c8b00bdc7fa3e70bd69e408dbab156fdd7899b871e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    manifest_sha256 "a8a15eb3462d2d84448265795363c4ad7e5b42b9098c8fe2033beac9ba06619c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "81eb8f77df890e38e7d7e6eb261f5d17f03db74568f30ea81aee5275dbed5272"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9186033eaa51f191813e717d51258fe8681feb5f0ec1c6870d250a8b001858b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "14bdcbbc4bba32014194ea7d3b3969ca35cec2a932554fca6c3877ccc03eea5e"
    sha256 cellar: :any,                 arm64_linux:       "386b219da289819605ed9f9efbbe381de6f01255ac536ca10bdebf615b96c21b"
    sha256 cellar: :any,                 x86_64_linux:      "fc8501c0f6911e2aab76fdfa04193f282ca3e8c9506929a70ac197cf16927ffc"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      system "cargo", "llvm-cov", "--html"
    end
    assert_path_exists testpath/"hello_world/target/llvm-cov/html/index.html"
  end
end
