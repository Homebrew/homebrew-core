class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "a110b37436de725e59bb5b51c7343be93ca41426c0226a2cce5394b905016d3d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f130eb77f7897087459e7871302b4052fe7d38ddb9dfc053bc3169a0e2b1137"
    sha256 cellar: :any,                 arm64_sequoia: "5592ff19d5a03f57259fd03a84bb5a2ded571637de542f71a6fd11574fa92029"
    sha256 cellar: :any,                 arm64_sonoma:  "b10aa7f7ef215c74e883b14c305635b48b372a9a61455b72dd4c354f7fa4877f"
    sha256 cellar: :any,                 sonoma:        "ca9d0f22edd428675ef0c562b071d34a4260aed20a2912b66cb2a93999a138e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a9d580c9c92e1e6e07d3160764fbe08792998edc3576e6480a07819cc850ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52473287033fccecb3474101bc3b6842ab0a3c816f04b923831ca431d60593e9"
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
