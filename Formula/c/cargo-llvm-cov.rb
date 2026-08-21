class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.9.0.crate"
  sha256 "cc4d894e2ff02b503a59b14c17bf1e9939a8a9a8f9dae38245f9acfccb12b7d5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "910147a3e06787146f679f73a60ef73d38a29fef7c16abcec412f9a1aa87aa78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b278a10c2187cae52648e07accbb1e6f873f9f53a73726ac57c843ce96665596"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b19ca88cc0ddfcc34e3fadaa6f19df09bee4255f21df67ec4ae9803335f42c62"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3e69664bb21c4dc968921b04b896ca82cfd2985b35d62023f04db32dee7af27"
    sha256 cellar: :any,                 arm64_linux:   "1d6a0a30679ce0c723e32fee5cb9917b13ffd976b4b7022b06ad95dbcb8d08a6"
    sha256 cellar: :any,                 x86_64_linux:  "0619ae89ba9ce47b606b074f7276592ce6ee0ce20b776f47ebbc90b8a49b57c7"
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
