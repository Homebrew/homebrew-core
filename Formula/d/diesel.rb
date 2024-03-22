class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "a415084747a0c5dc5c1042fe9c581287d04ebeb44f35a99e3214ed246d5124b6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b9ea6fddb980f6c42a929ff6572b672aafa0dfcdd6461fc0eea96441f98331bf"
    sha256 cellar: :any,                 arm64_ventura:  "573472b2e95eabbe3576276df28a8c481c7bb8756350d5893a3bc56ef7b5630b"
    sha256 cellar: :any,                 arm64_monterey: "fc5d6298ca72ffba6781b354e4789808c0754bbf025e0f1459d31a2154b4b5b6"
    sha256 cellar: :any,                 sonoma:         "8950ed52e76e597e7b36663bf7e934588955e0c38ed831d791253c5730526a41"
    sha256 cellar: :any,                 ventura:        "82789c59492d03bc75c382cf97829cef5975a3f280bab5cd514c513d73d8b37c"
    sha256 cellar: :any,                 monterey:       "d50c8e2825480776ef291437dfdbec430606dbbbd56114b82cbd216bf77bf38a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c397c227673d3201992b59ff51a5a8176dbb11d5b636bdee645bdaa2deb4a38"
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
