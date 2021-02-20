class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.7.3.tar.gz"
  sha256 "533c65d555330e86b91415753efc140ffdb900abd59b5b6403352c4264941a99"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ae5d43a195dc94aeb80c0110822f8eb94fd4d2d758dd51e394fd81b5cbf14afc"
    sha256 cellar: :any, big_sur:       "bef3ef700fd4e9cce5b7287a7103b2128b06fdb530c20d936baddb0708fe7987"
    sha256 cellar: :any, catalina:      "5adc9772a6c58eff96522a8505b726d380c8627e9e9d9fe9b3a22d68fe42b4b0"
    sha256 cellar: :any, mojave:        "97a83b63745a14cd44f97bc2de584b6888207b8120cf91d4d6f8b2c0cf7c877f"
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)
  end
end
