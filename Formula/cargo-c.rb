class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.8.tar.gz"
  sha256 "7c649061826e0ad3c2c8735718f4a0c4afd12eed9b9fdc5fe59e34582902e1c5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7e874b1aa94f5b0b72aee5323243cde55fa25ca229412c74aeee4468385466a2"
    sha256 cellar: :any,                 arm64_big_sur:  "41315e8b42829f138832b7793cc3065def8d8521fd0965e641d0bd5a09da5b48"
    sha256 cellar: :any,                 monterey:       "b03d125300c7bffd5bf6767ad0597a3ff3f998a79b024786d0876daba332d1b6"
    sha256 cellar: :any,                 big_sur:        "3502a3f8d548d65868efcf464042484a7b0f41438a679027edd1ca8f3acaff30"
    sha256 cellar: :any,                 catalina:       "0394f57f7aa85e8922184331f256ba7d5597315e7a7a45cb07e693a01cf09ff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1f681b4860ef9f0d24918404cb4e7831966f26370acc9ffc8a944a9cfd2970d"
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
