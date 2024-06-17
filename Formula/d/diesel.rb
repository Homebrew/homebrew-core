class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "433c6477d73177036a0e9188bcb8fd9bf31978ddbf3a69dc6b87b774efffb271"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d4ac45e61c3a5ce21a2eaf68f453274a36623ab72aae5c862abeabb7358bf6a4"
    sha256 cellar: :any,                 arm64_ventura:  "12efcdb7bee93978bce2232b5621228a556468cd8d71880e4977e77ce78b3c88"
    sha256 cellar: :any,                 arm64_monterey: "ee5f567574047c885522f1953909f46c133164f2681bfba2b0d295cee78d5925"
    sha256 cellar: :any,                 sonoma:         "239d73e367452a12cf378c6254a6124615013fcf9e5bf32b0aef0d2cd376cadf"
    sha256 cellar: :any,                 ventura:        "8864e56fc73dcdce0189ed2a6e240710fb5bc879d8af1d151b62bfd23181a717"
    sha256 cellar: :any,                 monterey:       "f1e3fb673e8a1983eac7e154df8a7de26fde7250cb2bbaeec0497e165f94b3f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28ba1527663688bb5408c6f7d2693429405cbfee07c0231bda0870d6fd3d193d"
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
