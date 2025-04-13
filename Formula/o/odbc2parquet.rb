class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://github.com/pacman82/odbc2parquet/archive/refs/tags/v7.0.4.tar.gz"
  sha256 "91ad4087df787f9b81457ace7de31b9f4daec8f05d83b34a52281feda3391ea0"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8c333200e334b67dc8e05e38074cc6b46c02aea98982529e42a5cd67ac527800"
    sha256 cellar: :any,                 arm64_sonoma:  "4c2e2615e4ab5c150075ca04622abf269a0d29101549c3b06d17d8b8537f7e8b"
    sha256 cellar: :any,                 arm64_ventura: "1f52d4226f1c3bf68e0d90ed80138934361f4c9faa17beb31ed5c076cc38e760"
    sha256 cellar: :any,                 sonoma:        "2498e25900e51769c8470c911b28aa5ed06a9eb0444e48b486c5f3898ef363e2"
    sha256 cellar: :any,                 ventura:       "2a15811948f51be317892bd6bae72031a38e84a70c8b70ee773a8ce37bd91067"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d44163d34daa97cbdb39780ea0523540f32a7810cdd80eaf39551a8ee38574a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f12162a3b516650b4cc3f974ddbac6c1d10c02c1ba55cc7ded54e4932ab02483"
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
