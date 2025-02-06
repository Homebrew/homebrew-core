class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://github.com/pacman82/odbc2parquet/archive/refs/tags/v7.0.1.tar.gz"
  sha256 "37a3246f718c9ed3de277f9ac379b29cc6abaf74027c218404b9af6ebe2333be"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5669bd6f3b9da2e56a15bee8344deb16f43b72c866244b2fcb05a2a5ab455006"
    sha256 cellar: :any,                 arm64_sonoma:  "218b68a5d77dea343ac6e79399b30c838cc2abfc2fd5fafd0b9ecf7f277c779f"
    sha256 cellar: :any,                 arm64_ventura: "d9b52d5ae6185fc0c1d1b6657fa91c1b488ae3dde3119a6225a20c328988fe99"
    sha256 cellar: :any,                 sonoma:        "91a73d6f821e4dae8f6e3fbe52d495e7a9403ce677dbeea95cd585e759a9b76b"
    sha256 cellar: :any,                 ventura:       "67bdf05611523834534ab827dbc44f076d4a8aaea65ad155a4df64b26d3e84e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d635c3c25195c1c8494c3b2667928c84dae71e6fd199ebe3496a959e99ef03e3"
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
