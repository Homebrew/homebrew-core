class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "5fdbf6942dd3d52a7f3648ed5ea35556840dd17e768c9fa6897102a982b83088"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "033e3b37835736def3b6929f2f6ded6512b4c717a0758724c5b38a884c246b0a"
    sha256 cellar: :any,                 arm64_sequoia: "a227481c023500d95b7b83dc222cafb79cff83349a73afd3608c172cad6928f6"
    sha256 cellar: :any,                 arm64_sonoma:  "31d7adeb886860858f4f300acf77943b1c12dceba5872d37b1d2fed95a9c0507"
    sha256 cellar: :any,                 sonoma:        "9347498e220f2e0c979e454208305ed35fd06b16ea897fc8804fb918dd63ed6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fce354eb98bae83dff577066507965c634c4fb0d8faadd1c5ba230fc7c32e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b26c42c19727fca6d8c16c180273a6b7c3cf8292194cde94c49aaa92cf0a2a23"
  end

  depends_on "rust" => [:build, :test]
  depends_on "libpq"
  depends_on "mariadb-connector-c"

  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args(path: "diesel_cli")
    generate_completions_from_executable(bin/"diesel", "completions")
  end

  test do
    ENV["DATABASE_URL"] = "db.sqlite"
    system "cargo", "init"
    system bin/"diesel", "setup"
    assert_path_exists testpath/"db.sqlite", "SQLite database should be created"
  end
end
