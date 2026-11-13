class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://static.crates.io/crates/diesel_cli/diesel_cli-2.4.0.crate"
  sha256 "84223d1adcb1618dd0f68e7b309099d1323c59541eff336a8b83a7066edaae89"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1dc5eccd97bef62f0911202574b3f61f1cfa0b32ba1ee7e06da5a7a8040b97a8"
    sha256 cellar: :any, arm64_tahoe:       "594c64dc27e7d589805e3fe8f5c94c9d9b0fac8786d42d167ea8d3f818ee17e4"
    sha256 cellar: :any, arm64_sequoia:     "f8ce5d337c7b5044473699b39025ef35a7fb444bc2f7030925576b38ed55c54c"
    sha256 cellar: :any, arm64_linux:       "77ef55b59a4797ac6f882511368499195e1f5761574c5a290008db511c6a7ec0"
    sha256 cellar: :any, x86_64_linux:      "6623dc31fa4f2195643328588bf17208f9b18ea18531be26d5c092a3973c7ff1"
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
