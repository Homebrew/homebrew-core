class CargoFuzz < Formula
  desc "Command-line helpers for fuzzing"
  homepage "https://rust-fuzz.github.io/book/cargo-fuzz.html"
  url "https://github.com/rust-fuzz/cargo-fuzz/archive/refs/tags/0.13.1.tar.gz"
  sha256 "3dae1ab57e738c1059635eb824062e4de79474080612f60a0ec0decf455d9e65"
  license all_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d9d7d1111688f24dcda6cbc4daa6cd6a7bdbf7a24409c06dd83d2e55248c8fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b956962a95b2090fda39a65ff4db87e26bd410c28d2e82671e767a260710e5ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a3493095a73a28d8e9567dd14965cbcdec67ad26d01d475b4cff7962652d14c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04f19b1a235620309d46c4b2a1123e8396a155da418bec5b3c8b850cf999cd09"
    sha256 cellar: :any_skip_relocation, sonoma:        "893e1c8a1a414cb0c30e0a16a6b6b5d682e499463f53a74e15b243e958f84c89"
    sha256 cellar: :any_skip_relocation, ventura:       "9c9bc902d389b13ce19eb7c502776e2ebec0ca489571bdac1b3f77dd2572af07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "831f04c442358ca91759ab573aa45d5fbb9d0a4363e82e079cd5dcb24dcd26f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0be5af994689c2d68c333c0a97d5e2b71e1f2efee008131929a92cc76f097fb5"
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

    system "cargo", "init"
    system bin/"cargo-fuzz", "init"
    assert_path_exists testpath/"fuzz/Cargo.toml"
  end
end
