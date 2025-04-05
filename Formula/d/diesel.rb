class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.2.9.tar.gz"
  sha256 "c4632bcb2a4cfe5db6036abd15565b9898e4ff46a4493d8c21301a9e466b28c5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "abbc99d543cea69579b63adee1a1a920db0a3bc23202b4a1cc1046f0ef3f8800"
    sha256 cellar: :any,                 arm64_sonoma:  "fae99171ef51d390632736d5a2bdd12918485abba576bfec90aa99ed8d336712"
    sha256 cellar: :any,                 arm64_ventura: "d6c2f3ed273793d37338b985e2a7efc12c455ea3e35dc71dc81477259b5e6ede"
    sha256 cellar: :any,                 sonoma:        "c54b1de5a20edbe60bfde4f4ed5034a8a824362ede8ac520404168e2a65a7ab2"
    sha256 cellar: :any,                 ventura:       "b224b6daee039f726cbebfb389f8771c736c6cc4195b9b1bf2fd73b8e3525a4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cca7aa8c33be07c369d822f21bb7f3b02a783dd3b991f18122570d38604984a"
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
