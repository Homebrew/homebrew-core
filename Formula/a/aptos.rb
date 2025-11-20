class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.11.0.tar.gz"
  sha256 "8da83dcbf0eefa69bd5d4a117444c8cc65486c4a40c410efdd5d9d7bb425ef45"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ba19b2e4cbf0a9cb98855159e3f219a466f46a9b9ca87727fee87efc6843a34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f256017e13c6383b3eef1c87f865bc9ac71a0f801b7e2d84c4f8e26aff151ce9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e1d375b59c2bbf646d162b0d508a0c7ed3208c8c6a345008ca032dedb64bb0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdc985daf344876ed1f2c00ebd251ee4d78fafa13ae6619704b2abfcb1af0a2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7023f7a5600e98afb5febe687727b457030ae9038d6bf0e26ce335c2e8450f30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "709d0462bc0ac04b8f030f06b9fe213f9d45eb7d62a74fcb58e5134b9dd99fb0"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "pkgconf" => :build
    depends_on "zip" => :build
    depends_on "elfutils"
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    # Use correct compiler to prevent blst from enabling AVX support on macOS
    # upstream issue report, https://github.com/supranational/blst/issues/253
    ENV["CC"] = Formula["llvm"].opt_bin/"clang" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
