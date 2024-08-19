class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.6.11.crate"
  sha256 "a18c672177efaee994adc1127c8dceb705305a9da482724227ca90969964f06b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "616e9142d3eb8066f70e164926bf4fcadc6aeb9ce069b424f7f63c33c3b283aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aab8871dd22963b74f06b94079fc264e2044ac54e90618c816ad5215bdce78fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6c1b84895cfa529ffd6d227f2589acedcea5b3aceffae01506aa7f5585c92c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "d95b5abb5b4bbe37aa5311766cc75f62b124617a7d5c439c6b9ff4ee697f5a95"
    sha256 cellar: :any_skip_relocation, ventura:        "23d2f8c9fe4a28c7bda5ab4bd64f270d5ac8e75769b10bc90f68a1ebb42870e2"
    sha256 cellar: :any_skip_relocation, monterey:       "83a60e58cc9a19d97f85e52de8dee65a9229f3363ee4431b49d26bdf277f6a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d05c7ac852d3e7c39dda93d37965bb38786c6bfbf71b5a03ff59f54321f6285"
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

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      system "cargo", "llvm-cov", "--html"
    end
    assert_predicate testpath/"hello_world/target/llvm-cov/html/index.html", :exist?
  end
end
