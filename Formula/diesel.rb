class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/v2.1.0.tar.gz"
  sha256 "0c530935a45876006417e8c9668088de7bd7445e8846ea859ea66f98d6e667cd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7987c89c4a455c579a536cbb112446f4ad08484971a46717b5ef21bc40e1eebf"
    sha256 cellar: :any,                 arm64_monterey: "f0894474786994292026121d47b3792a49ca13a6f41a4f086866d380a46e2a62"
    sha256 cellar: :any,                 arm64_big_sur:  "2ee93e88d7371055c997b2c1a3d9c2bfd70ec906da083b3cdc6877f4730d85d5"
    sha256 cellar: :any,                 ventura:        "17f0b276730f08426cdef5d2355aa384c29e3edbfd28d5ffa878265ca05a4071"
    sha256 cellar: :any,                 monterey:       "f5c138b2fbdc46cf12248c3d5fb85779005a7a0d938a2810cc9256fe39683b32"
    sha256 cellar: :any,                 big_sur:        "22bcb5b6aae2437b73ad358fa74b0a11d5569fd14cb9c992607aa8aec91ffbf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79c05cf97e37861d09035d0da73503fc1c37cf445fa3be234d18973a27a48dca"
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
