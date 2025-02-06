class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.2.7.tar.gz"
  sha256 "8125fe5dc1aa24e823a182ed721eaa3a8340bff094ec3a3339fbdf3e59749eae"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6ece9b7b589213b1e5d76f9d00a0efc5094feb28b4b9c4004820c257b6e2d33d"
    sha256 cellar: :any,                 arm64_sonoma:  "079f2bed063bb953f1ee5f88d5759c90cc06527a1bd385784121f0197698d0c3"
    sha256 cellar: :any,                 arm64_ventura: "ac3a404e0ae39de2a9dcac3cc06b7a66694f2ff6fc6218ead26fb3e7fe7e2ecf"
    sha256 cellar: :any,                 sonoma:        "df9470055cff5d8540411d61eee2190b6f3b3da396e5299cfd5661c5657fb724"
    sha256 cellar: :any,                 ventura:       "73a0b69b180cc97f4709f1c998a41fb076d3cd968380a34468ae1d7b028015b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e259d42212cccc6fb862813936ee4c40b1144dee31bba5c3cf2083b8ab82fc33"
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
    assert_predicate testpath/"db.sqlite", :exist?, "SQLite database should be created"
  end
end
