class CargoFuzz < Formula
  desc "Command-line helpers for fuzzing"
  homepage "https://rust-fuzz.github.io/book/cargo-fuzz.html"
  url "https://github.com/rust-fuzz/cargo-fuzz/archive/refs/tags/0.13.2.tar.gz"
  sha256 "88e179805e4fe4c9903720a004ef6903b0f28b27a22e74660cd72f58612f6b46"
  license all_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f2298d2812f241759c9da9cee5a6cefa95e3e74b7b11beddcf5327f550ddc07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cf24b5991c5adbbd222d3f8d1ecb9c86a0380bcd87435e77ab62e19f3e1aa7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "438772956ddca5b1f4f93b4d74b7167754e1932f7af4f3746672f3f0fea0dd0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c80132c2783913dab11f06ded0e53d9970406f60960998f00b38e7bb9b4d2ee8"
    sha256 cellar: :any,                 arm64_linux:   "a03806a4c09fe3707a3cdc6de36ad214c37de84da5a0859972c6ee70bdced847"
    sha256 cellar: :any,                 x86_64_linux:  "a1e48e04e802e4da4b73f4481f3a2543cdfaf759e09fec4c31fde244221e83a6"
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

    system "cargo", "init", "homebrew"
    cd "homebrew" do
      system bin/"cargo-fuzz", "init"
      assert_path_exists testpath/"homebrew/fuzz/Cargo.toml"
    end
  end
end
