class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://github.com/pacman82/odbc2parquet/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "d0f311edd3b6386b15c1510a03c9dae088ef3ce680912545e9f3ceecce340643"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ec29707b33d331e1289bacc553550225ecc0d4919ed6f0a37eb04631b7f5eb91"
    sha256 cellar: :any,                 arm64_sonoma:  "758e0d65f61d16d76f95b2c0c28ce1b7f4361cab11f476ea78b7104a7072ce58"
    sha256 cellar: :any,                 arm64_ventura: "3396a7a65d0ab6c85f140aa75d85efc9fdd85338bc83af0b190790fd05c171b1"
    sha256 cellar: :any,                 sonoma:        "b57e6021b2ac0e23978793a886ad96b862ba992fdd24c2cf9052a7cbf64afaa6"
    sha256 cellar: :any,                 ventura:       "393a7afcc299f124264980c9db43abe8ca36f0ff3cbda29d71eb70d5d9a11ffc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14ba98ea2068f86bb9f950cc06c0f396e90dd94addcbf1cf310a94ef55e33969"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e622159247dcc3876ef43754e852e87f47061a98224d2ce962d93c25d9d2a2c"
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
