class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/v2.0.4.tar.gz"
  sha256 "34452dde1c59bc2b1089fd442e3073e0329d23d8a26306b5c31a3f89de5f04c5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "97b46da4270d14795eaf0facac440dea66bf5b06f2fc9b0d7cf981d147f017f7"
    sha256 cellar: :any,                 arm64_monterey: "9b93d5f2f5cd99716be34a38edb73322e77361f1a6717244c98434c3e73e075e"
    sha256 cellar: :any,                 arm64_big_sur:  "478667bb92b30918b21c34ec3c1c570d0334918d2c8689ceaceb0a06f32b6677"
    sha256 cellar: :any,                 ventura:        "2a49116e3dee26b3c3788b36ddd78dfc4af626fe59af24bb4682596fa36fea69"
    sha256 cellar: :any,                 monterey:       "2bb74a52d94e1dae41f3be70d5f183967e7de1c68850a5a9702b0b6a7a95a238"
    sha256 cellar: :any,                 big_sur:        "2b3f37e34b9c03de77234f8c130e1ae31d1504f2fbe5e14637d96ff1c261146f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c54e022112e08bb1c9250e87afd8722c5ebfca579b4179568587a97891e3a8b1"
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
