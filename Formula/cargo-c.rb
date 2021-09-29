class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.4.tar.gz"
  sha256 "8965b1381f2c6fd040a1b930bebf8d1c12646dd7be43d76a23bcc0edf37887d4"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "6d05bfbfdd34307787d414b45d195e2cb342df23c46a845594e03b99ea71d73c"
    sha256 cellar: :any,                 big_sur:       "6df743b23f36230dde5c80d15cd96c48737d3ae04e2dee2bae1b9087e2ca5753"
    sha256 cellar: :any,                 catalina:      "ca55eefdaf743e357676c301424e7ef5b98e672047b012b3dd22dd637f73bd8a"
    sha256 cellar: :any,                 mojave:        "e49f2315ee7e0c2a1d1306ebf6be868ffd7cc4fc6b32a9252e132838533b5e2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b28d2f7c4473ab36172a01d16262912deec0ca1af8738d7d1ba676242cdce80c"
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

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
