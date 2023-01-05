class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v1.0.3.tar.gz"
  sha256 "670bb6cb841cb8a65294878af9a4f03d4cba2a598ab4550061fed3a4b1fe4e98"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "rustup-init" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    system "#{Formula["rustup-init"].bin}/rustup-init",
      "-qy", "--no-modify-path", "--default-toolchain", "1.64"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "cargo", "install", *std_cargo_args(path: "crates/aptos")
    bin.install "target/release/aptos"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
