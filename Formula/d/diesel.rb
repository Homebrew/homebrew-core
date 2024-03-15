class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "a415084747a0c5dc5c1042fe9c581287d04ebeb44f35a99e3214ed246d5124b6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "515154489d83510a1b766c1c560e20aba0bf69f4f8a7e4c5ab61422d6239abb0"
    sha256 cellar: :any,                 arm64_ventura:  "2edd7c5f90fd3d7dfd190f68a9f9581f807c491f9ed9226be5d9f62d2ac1ea10"
    sha256 cellar: :any,                 arm64_monterey: "e583cab88fe4efc422f2ec56943bdd538839260225d12a8dc4d17ca14fc6ffa0"
    sha256 cellar: :any,                 sonoma:         "88f90b357db55926639fc1e332f17f26e59212172a83e43804bb76e2d30a6f7b"
    sha256 cellar: :any,                 ventura:        "6e865c89f16d987c0da2bd313980749508768383ef20b16318ac205aaae0d635"
    sha256 cellar: :any,                 monterey:       "1caa005a57decc61b66eede1f5f499640c2a4c1c0ccb9af96f38c2cc19273d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6abef19ae2e350f2c39df6a3acb3f5c34c3a585652fbadc77abcc2bc54c958f2"
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
