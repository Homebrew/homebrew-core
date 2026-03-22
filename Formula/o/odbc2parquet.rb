class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://github.com/pacman82/odbc2parquet/archive/refs/tags/v9.0.0.tar.gz"
  sha256 "22f123a29d29a435a881adebece56154204ead2c6ce7dc9b5b8d128dc77afda6"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "99df96eb4d73bc70708908c7b6a75bf73ebed8b2af94ea2994667d78395e9f78"
    sha256 cellar: :any,                 arm64_sequoia: "67c3dd54eca980e404629d9702300257f2791eeb93c369e1c7cf01766cf22eb1"
    sha256 cellar: :any,                 arm64_sonoma:  "31b6dd2da1099b1f22e722286a83e90bf0e06da9d24ac2433a592ad49c14261b"
    sha256 cellar: :any,                 sonoma:        "a962e03f312a2fe3a06ba07f107b20f6333ba6dc0eef98b81e9dad0a35cf8fc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fb90bb872b855d6d4f3252f324ddad76512bdfc31cbd5eb484ea194e82b9bd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf17b60278f788a2ff577ccd6edb20aee0e7252e7e38de01360a2e9432b88b11"
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
