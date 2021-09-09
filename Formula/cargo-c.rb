class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.3.tar.gz"
  sha256 "0e0e7d1f6490e47195f8d02e6b6eda058ec815756fab1ec8c811e1f644cc68f5"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "cf99c33bb6c18c88ff54bb8cc6e8b960f11b196b9920c3c7606b213ade0a0d23"
    sha256 cellar: :any,                 big_sur:       "11ac69375c66991e9d4a94c71fd0bae2abfd5199a26b550a30de57f6ec073a36"
    sha256 cellar: :any,                 catalina:      "eee0d8bc25e64da0f08f7b95595542abdec8a47d9b436155dd86fd55734b02ac"
    sha256 cellar: :any,                 mojave:        "f3bfc845a2bba4b1ed42d4a16bb49ca0c7889f4345caafd098c52e946687a905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ecb5fd3d6fcc38f58be9c57f6b367df4a702ae8c8f73023fe014cd6d34da24e"
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
