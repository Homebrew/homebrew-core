class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://github.com/pacman82/odbc2parquet/archive/refs/tags/v7.0.0.tar.gz"
  sha256 "64099f39b803d62ccc4330b09ce86e278480b1547c4b4a8dff50f8c413cc52ac"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bf0414719570a3df4c9e39bf9d2c46b0f24568947c8206c0c5e386634727233c"
    sha256 cellar: :any,                 arm64_sonoma:  "9bbb399ca77dfde3299ce5e38cf5ba454aaaa575cca54ce77efd5f86bd1f60ff"
    sha256 cellar: :any,                 arm64_ventura: "baed2f55e982a3aa8fa9352030cfd25efe0e647ca474972db15b2d3e018faa93"
    sha256 cellar: :any,                 sonoma:        "e3e5a3da044739bdc6ba6e48cbf107e64e359c827f945e73c1ca9efbf263024c"
    sha256 cellar: :any,                 ventura:       "cc1b0405880bf01950039222d1a90875da3d85cfe44b9738b07d4bce45ff4123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d40e62a1a50db0bc5c41501ead0475a2022f5982d3eead5a15fd3896a1e1648a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "unixodbc"

  def install
    # upstream patch PR to improve dynamic unixODBC library path handling, https://github.com/pacman82/odbc-sys/pull/50
    ENV["RUSTFLAGS"] = "-L#{Formula["unixodbc"].opt_lib}"
    ENV["ODBC_SYS_STATIC_PATH"] = Formula["unixodbc"].opt_lib

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odbc2parquet --version")

    system bin/"odbc2parquet", "list-data-sources"
    system bin/"odbc2parquet", "list-drivers"
  end
end
