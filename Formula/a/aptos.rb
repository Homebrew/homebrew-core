class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v2.0.3.tar.gz"
  sha256 "4b76639b3758a2990a0b54ebdcba6db99b89d980b5d3e45a63a22d5344391ef5"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3f59bcad940a142226d617f2d4542b20937bbccff76401e14fe4cd89aeb4079"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faa8ff58a53507bbe504eddc07599bcccaf4dd46227aa8f24e90063e598e155b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65101ccdf8175ac0f15246313820dc4b7b8f1b182637a438a0d4aad1b63d3f3b"
    sha256 cellar: :any_skip_relocation, ventura:        "8d1bb781238baf3f12e79df3da65228de2dee1a6203b720a8e473d9f9afd624d"
    sha256 cellar: :any_skip_relocation, monterey:       "8c1fcf9a4c1723cd45381f7d060e78cf3d440ac4463c4eb7ce199a9e670b2ff9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6616de72382fada4ed37d6c444c1c70a71d776b08c81a9c77432368d582f008e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ca17dbbb150e9362ff9c623af3904150ddf0b9b79c4d39e156be287b4758139"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "systemd"
  end

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    # FIXME: Figure out why cargo doesn't respect .cargo/config.toml's rustflags
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))

    linked_libraries = [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"aptos", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
