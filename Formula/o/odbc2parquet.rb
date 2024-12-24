class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://github.com/pacman82/odbc2parquet/archive/refs/tags/v6.3.1.tar.gz"
  sha256 "02aaa8358311f5551dc8c966563ac2adc637897070717da2249611522f3ada9c"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

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
