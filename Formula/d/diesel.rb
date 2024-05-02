class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.1.6.tar.gz"
  sha256 "60775915f615d41b65f31861ed01e467961677b7e430c6cc58d22c0b9bc17baf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "efe80bdd1ea73bc18a3f910e8c62ff2f04332aec1d8c45c1f7c7a49957199708"
    sha256 cellar: :any,                 arm64_ventura:  "6496942505481116a5be81a5225d0039ea91cdaa8c794eef4177133b5571f1df"
    sha256 cellar: :any,                 arm64_monterey: "2ec7545e0e73b5907dac1cb3b4a07e8afa5cfcc9085885db3b3d38ce810503cf"
    sha256 cellar: :any,                 sonoma:         "6026762db5d82ff4a24748115b81ac93bb8852dad5fd8b8fafeaf6874bcdbd5e"
    sha256 cellar: :any,                 ventura:        "8e2aa465ddefee98e147a5fc6f78681c4a31ff3b9ae9010a2d3aaaad1750387c"
    sha256 cellar: :any,                 monterey:       "e600b47c31902eb67d70ffbf211952f9ca9211350233780a9bc3852339ce08f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebb91ee005288c425def9da870ff6c51de494e1417d0ad52d486e2297a44c5c1"
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
