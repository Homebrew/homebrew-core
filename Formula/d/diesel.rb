class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "519e761055dea9abf6172b8ec15c0fd0da53c859e6b6809daeb104bbecd6fe57"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "31e2374ec71891eeed4e6ac413aaf878e86fd5abf9a801fc8391ad3a5279ca63"
    sha256 cellar: :any,                 arm64_sonoma:   "d75cce8c52f8c343cbcc9a94b03705e99aa480ebbcf678d612cd2fdbd98d8b9d"
    sha256 cellar: :any,                 arm64_ventura:  "4eb44dec232aa975d392b48a41ea5cf9f5e1b548e85113175cedb354ee224c0b"
    sha256 cellar: :any,                 arm64_monterey: "e0cc0f7623c8188e032e57a5ac1b6cb2329dfd2dfe76101a7cd9abf66c0fcf73"
    sha256 cellar: :any,                 sonoma:         "36b15705649d70cc7a8d6f53751c9e8c5d49140c8e594639b037288768d97119"
    sha256 cellar: :any,                 ventura:        "43ee571371293e18488964b71636a3101898f365709af26ed6cf47522e065710"
    sha256 cellar: :any,                 monterey:       "d80e8fadf7f528f081c7591f46641530269b031e0b96e4ad6dd0d4552057d64c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dea99a1c98fc0d9376737db7737606f1a79b427dca5deced0c5b498e81f4a79f"
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
