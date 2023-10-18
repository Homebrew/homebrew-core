class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "de6db282d4f805de0b95b28079a36721b6233f4ddded915d4682cbb4edacf957"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eb5cefe5882fe3f7eb49355164373f0b39d9e69ddfc6e5a871ffbf680795dcc1"
    sha256 cellar: :any,                 arm64_ventura:  "9bbfe7dc417560fbaf4114355e6da0d8743f9d878ecf78f688810cf5c409e49a"
    sha256 cellar: :any,                 arm64_monterey: "2002fd5a7e4440b9ae10f3a9d6fc77ce83a5cfaf50311a005752a057a2e7c519"
    sha256 cellar: :any,                 sonoma:         "a635fc75cdd703528460252ecff6d3bc37d0f3dbd3b19436bd8e48da8d715245"
    sha256 cellar: :any,                 ventura:        "77c619d1eb569085ac28c6de2a523c76506272e291a36a8feb4fc7c6292820f7"
    sha256 cellar: :any,                 monterey:       "845b9b2a4552f8bbad099a538fff7b1474f0601cdbcc9859cb731e1a5e79a93f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e5e0ef52dd79cee15b38d257e3e4c847f98c8263308eb14fe4bd33ad368fee4"
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
