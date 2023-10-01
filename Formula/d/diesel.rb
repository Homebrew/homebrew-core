class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "8eef8d21395a0a8d72095b726f8375f265ede0264f9b2aaf827df526ca79a03f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3ae35851ed6565bef3eda70293f5810289cdebfd37cb884df410b740ca706a3a"
    sha256 cellar: :any,                 arm64_ventura:  "71fde7943ad47f88d04ba324df59b71305351e4838a25463390919d5d88950c8"
    sha256 cellar: :any,                 arm64_monterey: "b69f998f059bc58bc4382515dcdf83643fcf70e0311f913e0087e6c0d289dd48"
    sha256 cellar: :any,                 sonoma:         "348e4f0c849b3df44bf1cf9e99a7f88c2a3dcab5b7b3e202725e2c938324b914"
    sha256 cellar: :any,                 ventura:        "ea8c54182f67e845c5815120d92556835bdf2bf7c82c5c62423d15f1a0469ed6"
    sha256 cellar: :any,                 monterey:       "e0b91dee34d665614813ba67600186470d758f598af72a0b5196967c063313aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a430e777658bb14375946670db1d4754b1368f43950ad2a76dc970c328b1722"
  end

  depends_on "rust" => [:build, :test]
  depends_on "libpq"
  depends_on "mysql-client"

  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args(path: "diesel_cli")
    generate_completions_from_executable(bin/"diesel", "completions")
  end

  test do
    ENV["DATABASE_URL"] = "db.sqlite"
    system "cargo", "init"
    system bin/"diesel", "setup"
    assert_predicate testpath/"db.sqlite", :exist?, "SQLite database should be created"
  end
end
