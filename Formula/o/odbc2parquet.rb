class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://github.com/pacman82/odbc2parquet/archive/refs/tags/v11.0.0.tar.gz"
  sha256 "3cdab5d19692cedcd3d8388a300350d44d7c779c535acb3a43cee3d54974fe12"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6208f54aa6bba4c5018532f8641bf8b85b1a49df545b18baab2f5f78d40fe22d"
    sha256 cellar: :any,                 arm64_sequoia: "51d3868c5562cbd6806e09cdc7643b6f955466995efbfb8d2c264d0ebd1fc665"
    sha256 cellar: :any,                 arm64_sonoma:  "b56da333c74a8b21618c91c27bed345bbc502d1fc2a543378e915b5b2480d909"
    sha256 cellar: :any,                 sonoma:        "481f3143707175ba4879b5372488793ce7a14efd8f986f7a757d8cda98035386"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe01d3df75640f667095ce6a56db03f2ec58ed162989f3b4eb3f300c0ba9a78b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "370f9db660bef0eabfaf967896184c0b95590bb4cca81a3c0df5e2fc8bf1ea9b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "unixodbc"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"odbc2parquet", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odbc2parquet --version")

    system bin/"odbc2parquet", "list-data-sources"
    system bin/"odbc2parquet", "list-drivers"
  end
end
