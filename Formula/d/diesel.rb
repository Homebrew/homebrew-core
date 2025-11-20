class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "11941ce0131aede9cfc915eaa8696cab650d528634a9647fccc853d96889f2aa"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "48a9ec6b615681d84872079aa67fdfcf033fc1de66d916240da76fc088f9351d"
    sha256 cellar: :any,                 arm64_sequoia: "201df54d961b36e0dfce8301bd248c3affcdb36f7a3ec8c7e567c04a64eaf236"
    sha256 cellar: :any,                 arm64_sonoma:  "53cbb408e82e2c1ff179222710222aba3711bfcf728ba90bab584b71507e931a"
    sha256 cellar: :any,                 sonoma:        "6a1242ccc1d91fddb0ba1270cbb0b05b916e9c31ecfb8ea7a39bd2e1cde371fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "799c340f9c8ed9c1dcaf1843c8a001a0a3443ff0ce67ec70d396bafef97063ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c73eba3aaff0e3da78acd920be5dbeb16445d1001478d11313314b1f401c58a3"
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
