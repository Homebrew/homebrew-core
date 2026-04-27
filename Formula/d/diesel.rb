class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.3.8.tar.gz"
  sha256 "479f41768ee2067f80cc02c7f5d4501702d22cda70619f30e50cf6f16ffe13d8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d19b463e46a8f513ca0ef937189043f3efdae83dd58f23020190353e4f7738a5"
    sha256 cellar: :any,                 arm64_sequoia: "81090956adb23d9c9cc973121e257a05ac1041a878ca1af236ce647b8c413b57"
    sha256 cellar: :any,                 arm64_sonoma:  "5c792e6d189182d65340c4f6b8b70d2c8863a8799a7cf6108fb88d50f8c21ec2"
    sha256 cellar: :any,                 sonoma:        "3c99d501c92b9842bba20d38763b621fdc91b34a27c4eb18d6c38438b66dc8a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a786132e941b383002b62922d0b756347a11c90d3923710f4179955ebca802b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52bf00bf5418d91e82873652f01662e20c51783baf43803700bb8e08704c64cc"
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
    system "cargo", "init", "homebrew"
    cd "homebrew" do
      system bin/"diesel", "setup"
      assert_path_exists "db.sqlite", "SQLite database should be created"
    end
  end
end
