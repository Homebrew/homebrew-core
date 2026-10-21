class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://static.crates.io/crates/diesel_cli/diesel_cli-2.3.14.crate"
  sha256 "0d10dbdcc7e8c4cb84e9ff9b1d6623b981395911b585e3bc753af9a31064c4bb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6ecf755443c6194de77dd2a594528b5dab04a6ff64f8604a18c763bf882f095c"
    sha256 cellar: :any, arm64_tahoe:       "7f9b0df10f9bc5d49228f7916d265458801bd4b22f37750242fc8623fd9c8835"
    sha256 cellar: :any, arm64_sequoia:     "8d9567c08ccd66a2825512ed88e145c05969bb6057df65d0d0c56941ed97ff3d"
    sha256 cellar: :any, arm64_linux:       "52bd0da9a6d555b17ef710ec5fa586a7275fa78092ad7fd01f86053a69773efd"
    sha256 cellar: :any, x86_64_linux:      "3382d15967aedc89c7e7e0889151d451f691f8bff4d8c2e203859c82e6c8700d"
  end

  depends_on "rust" => [:build, :test]
  depends_on "libpq"
  depends_on "mariadb-connector-c"

  uses_from_macos "sqlite"

  deny_network_access!

  def fetch
    cd(build.head? ? "diesel_cli" : ".") do
      system "cargo", "generate-lockfile" if build.head?
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    system "cargo", "install", *std_cargo_args(path: build.head? ? "diesel_cli" : ".")
    generate_completions_from_executable(bin/"diesel", "completions")
  end

  test do
    ENV["DATABASE_URL"] = "db.sqlite"
    system "cargo", "init", "homebrew"
    cd "homebrew" do
      system bin/"diesel", "setup"
      assert_path_exists "db.sqlite", "SQLite database should be created"
    end
  end
end
