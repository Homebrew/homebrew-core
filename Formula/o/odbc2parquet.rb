class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://github.com/pacman82/odbc2parquet/archive/refs/tags/v8.1.2.tar.gz"
  sha256 "2c0fd64fe00926a605218bbfc448c759e32698e369c2e6daeea3d8bebe8367c5"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d25527511260f24ad22d8fce5229f72decabce7c14895727fa06b57d4625ca2c"
    sha256 cellar: :any,                 arm64_sequoia: "906f09f28fbcf31b19b26c61c5322f6f6a0ea4e62830f82428419b241937ae70"
    sha256 cellar: :any,                 arm64_sonoma:  "73a73aa764534c128a912ed47d614f059e10ae506cc961e31c225dda049a92c9"
    sha256 cellar: :any,                 arm64_ventura: "16b30a8b76ed6b476ce22ab6570c56512901fb2a1feaa6974f0987c591a51f0b"
    sha256 cellar: :any,                 sonoma:        "51686c5dbabc6a703490a9947d1d89dcb73895e812e2dd1ef1d2c9db7d599e2d"
    sha256 cellar: :any,                 ventura:       "a6bbaacaf9ebbc1ee5cd9f52f84e9cc4c6c9209ccc395e7d0d22f01711485bf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09ab24fc635ddb56fd148eef6a6b1f0fa7d9f39cf8b611d82b10bedf6a89deca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ad497008fff1b9dd4b750227c4188ecea2322e2853effbb24e96e71ac59fe37"
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
