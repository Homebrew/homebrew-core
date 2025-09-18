class CargoCache < Formula
  desc "Display information on the cargo cache, plus optional cache pruning"
  homepage "https://github.com/matthiaskrgr/cargo-cache"
  url "https://github.com/matthiaskrgr/cargo-cache/archive/refs/tags/0.8.3.tar.gz"
  sha256 "d0f71214d17657a27e26aef6acf491bc9e760432a9bc15f2571338fcc24800e4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/matthiaskrgr/cargo-cache.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d569689e087953be570cbdb6dd283cdd09dd2242b864f1a3123e58353b3c39f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a88dd6bebd24182cbafb2adb0e6ee8cf348fdeb9e95111f0850725469a982136"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0eb3f619312917ccefece5cc1ea0711fc1d85f373122cca5b36970449317dddb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00a91483c1c50bb2e583c1e5ab9a41898b6b8b435b2d3ac61bfc736c49797871"
    sha256 cellar: :any_skip_relocation, sonoma:        "54dcccbf025bbd1cf5b018742d3b14c919e47c3777a16934b32e49b02c7dac0b"
    sha256 cellar: :any_skip_relocation, ventura:       "859498190a594da4d6f10908b807b524638bf398f9b029da99500da6efe6429f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ac3792893742e3bceaeaaa7aa28e36ff5de0e33a8a7e7abaa58d9fcf26230b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13787d990ce59471ceafc5846c2e2262453a91f5c2c121bad2a903af3d523796"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    output = shell_output(bin/"cargo-cache")
    assert_match "0 installed binaries:", output

    assert_match version.to_s, shell_output("#{bin}/cargo-cache --version")
  end
end
