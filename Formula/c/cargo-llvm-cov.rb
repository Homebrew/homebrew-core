class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.7.1.crate"
  sha256 "ffbef37d8b4c08b72a2fb5f47f5aab7a81a22b90c73bb4eb93d42c67cb1de31b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8f8c1d85b57046685a1422defc431d5429e0b418d6dc45540ed6bdc4378ca05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "983ada9eedfa36644037a3986df70a870b4abb6548b789e781f9437408f0ebf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4fbffc95345c0b5adb8d08665e2fbd3d5565afa6991c153ec870d58272ffb53"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8acf7c27cc525db98a8f8d6bc4a47d67238f0ae45562ab2558d993efe41f9ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "741ab5332e244361bd633f03207deba9a651796af867fa4ca23a3c0d930fea29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd8c82062b1fb5a46126cdc72bf247719d4c09ff4a4407d0eef95ad680954443"
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
