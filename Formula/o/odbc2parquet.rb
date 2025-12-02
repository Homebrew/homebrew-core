class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://github.com/pacman82/odbc2parquet/archive/refs/tags/v8.1.4.tar.gz"
  sha256 "983ab92b039646538e4196421cfd35c20d57b25d0a9cf6681965b77b39212345"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "01074b43af634ad1bd2d205ebc21b7be80cae9b8b31d2f0a415ba20469946c82"
    sha256 cellar: :any,                 arm64_sequoia: "3440017f2b99a65d65aa70159ef1a5913422cdb65c37258a125078afcce66d5f"
    sha256 cellar: :any,                 arm64_sonoma:  "6b3e20d37da68022e607c5d303510bd671542dc8a689db259830056bb24ecfa3"
    sha256 cellar: :any,                 sonoma:        "14677857dd5dd91396e347b546bfcf253a4f94c1ff43ddbd67b5db9b193c3df6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0d1d751e207c7dd937dd5c2e711f578f1b0d70ab97ac5f169cf333deecdc467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5fcd2cbaa204c2eff4099e099a393d1833681eb263aca31ec481d4b897a0275"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "unixodbc"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odbc2parquet --version")

    system bin/"odbc2parquet", "list-data-sources"
    system bin/"odbc2parquet", "list-drivers"
  end
end
