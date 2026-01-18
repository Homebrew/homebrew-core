class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.6.23.crate"
  sha256 "0a19af1cb5512737613b5caa313dd14cd56459732867c53a755da4b967ffefe6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a950eb38739fffe0f9d327d0da95deb0a3be472c89664861911c58c7a49f7377"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19bf2137acae99d89189001d6a3977aa5a3c0d0109d6317f47fc6e5c74da98d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb0e00510258c8aebfbb96e4a983c574e2db25d6ead4f5cbfaa8048e05683fe6"
    sha256 cellar: :any_skip_relocation, sonoma:        "398f4f316862bb6853fd21f95a74da8affd07786b9a66f69438ad903da398772"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e9c5ef5c9d786a8ee3004ec85aad5d21fe336b36df8f427ec6d831817ec3417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "542fa505ce0f351d6f9738e2809ec34872e789782a1954281122a64f63d2a5c6"
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
