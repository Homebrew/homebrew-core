class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/refs/tags/v5.5.2.tar.gz"
  sha256 "df68a9496db18f6f1e6e286a95ecdc5f3d25de38affe9872c650b4b004c1e2d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4ad750e572786954155600d9390fa677c28a0bd9636e950d27088b95da650782"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a743286e3d8034b3b49180fd7a0247f1a1dbef51d0f5d84403eebf9a9772e6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d3fda40993933e667d0f21ae8aa5646abac06d4e40a017be8a0d17ece10509c4"
    sha256 cellar: :any,                 arm64_linux:       "a9d67bcf72f432f61a07636111ce825406bdf69b0935dcb332b5ccc39aaca7f4"
    sha256 cellar: :any,                 x86_64_linux:      "a07b23cbec09bf482fc32eb253dc81105a268426451449527d06694016c0b5c5"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "ncurses"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"grin", "server", "config"
    assert_path_exists testpath/"grin-server.toml"
  end
end
