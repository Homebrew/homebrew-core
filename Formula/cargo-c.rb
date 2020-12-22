class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.7.0.tar.gz"
  sha256 "1cda5235cadc9f618168ea6497e4226856807f6c7fe4419df20bef8e67bfe9c0"
  license "MIT"

  bottle do
    cellar :any
    sha256 "2eb7fa7b5d6e8313048140d2c22153d0449ce0d739e9929864f9b213aab84869" => :big_sur
    sha256 "42e03505d070350cc568748e7d715afc484141acb0b643a1ad5ad5b903539c78" => :catalina
    sha256 "18af492bdc21dac31c79b3bd7c2b5ddcf4e6f0a81de3cb2bc7db7deb0a8205af" => :mojave
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
