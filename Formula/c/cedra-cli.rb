class CedraCli < Formula
  desc "CLI tool for Cedra Labs"
  homepage "https://cedra.network/"
  url "https://github.com/cedra-labs/cedra/archive/refs/tags/cedra-cli-v7.3.1.tar.gz"
  sha256 "904d46a492d47eaaedd3085ae939b9e5fade0d999702cbb826ed295b65f9952e"
  license "MIT"

  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "zstd"

  def install
    ENV["ZSTD_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib
    ENV["CLANG_PATH"] = Formula["llvm"].opt_bin/"clang"
    system "cargo", "install", *std_cargo_args(path: "crates/cedra")
  end

  test do
    assert_match "cedra", shell_output("#{bin}/cedra --help")
  end
end
