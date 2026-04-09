class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://github.com/pacman82/odbc2parquet/archive/refs/tags/v10.1.0.tar.gz"
  sha256 "8d3abceccaa2ad0357cb4b65e80bb36dfd3103b2f6f3a443d5e460a8e8d04a7f"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d8a62ee535bd42422dc776f278bad4265f1e393d012c6cb91f9c245d95d41222"
    sha256 cellar: :any,                 arm64_sequoia: "527dbfeaa57d90cbda5d5587f2f686a56be52e63b2355407160531f0ae393f9b"
    sha256 cellar: :any,                 arm64_sonoma:  "c1ef6e5a7816c5722cf145be1bd537168eadd2e262594c753fbf4b8ce7469f2d"
    sha256 cellar: :any,                 sonoma:        "e03b755372cd0bf11db23b8254e0b6d29c5a07e4eb0d09770c104fabbae85221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea444d818b009fb1f957d61dca83abc5c22e755ee33c91a8a1ab86dbebb4e670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e87f3d27360ac552e6a7eef51454195e0d585321615a8f48bd23dc650d58fee8"
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
