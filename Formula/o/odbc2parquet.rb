class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://github.com/pacman82/odbc2parquet/archive/refs/tags/v11.0.1.tar.gz"
  sha256 "1e0ba2b7c841a8e4c52a13a604aec44fa8f910ffb0b0375e21753e71dbcd21fc"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4dcd4ad1a4cd7389030d7b7bafd6c40e28f41c5aa433f7557b6ae6dafcd32cc0"
    sha256 cellar: :any, arm64_sequoia: "87b1aef161357b051ecb4fd5d8987f4e14ed79aae7ce5e91edf486f2176084a5"
    sha256 cellar: :any, arm64_sonoma:  "3286a42dce654c4835a83b0740200d60c33ce0c2cf8286e1ba3ce2039c0e4cd8"
    sha256 cellar: :any, sonoma:        "dd34990371fccce6df031a9159d489cada937ef8b0479971ce4ad4b7e856209a"
    sha256 cellar: :any, arm64_linux:   "8b1ebff41594d351fa0cbdf0910dc96b13d87576a01f1c65d9f75f82612833e5"
    sha256 cellar: :any, x86_64_linux:  "115a5ba97a88946c509c74a012d19feb4edcb9c1cca6f0ccbb31c2d532ef52b4"
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
