class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.6.5.tar.gz"
  sha256 "b4d697e0e75773041069ad2874e08a8ebe3f7341b47b7bc9ff825115dce910d5"

  bottle do
    cellar :any
    sha256 "0d8515bd572b544d172d07a53069bb0034f4d5129854825080392d3a76407ea7" => :catalina
    sha256 "fbdfc50d28ab605ce24220fdb7d413395e648726f7ebd15a5a04b8db3db8cc79" => :mojave
    sha256 "d543be27a0f8ca56927e9956071232dece581d20180e3ee357e8baa6e6ca8df3" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)
  end
end
