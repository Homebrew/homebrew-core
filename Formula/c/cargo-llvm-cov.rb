class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.7.1.crate"
  sha256 "ffbef37d8b4c08b72a2fb5f47f5aab7a81a22b90c73bb4eb93d42c67cb1de31b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0bc58ddd5c800d10f608942e4987ef851a5a26cb8b79bed44e4c8e3f11a1551"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07baddddbdcd3e02c12c3175b254da5fd79aa518c04b9c5f0b84d0c675c839a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e151b141a9a51dfaea0d97c7cd828a9ea3ad581b043587fc024fe45e7275bf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd1468cea9eef9c5d58b88145bb4a57aae420f4f6263963b3fdc5696d36edd83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7369e1ccd9c04d8db5300cccd4efa29c6e88dd9928102304737fe1b05fd57be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd55081267f7243869823391cdd08a7f5bc2bb83ed4d1cb606edb3ddd06b0fdd"
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
