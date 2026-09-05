class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.3.13.tar.gz"
  sha256 "3d1795761b4b48dc8b2c0e203c942ddfc97f767b5b59aca309f016e28cf0f6a4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b49ff817e731b1e59a0bf90d46bc483d54bb3eb56498c89f85ddd5281a881717"
    sha256 cellar: :any, arm64_sequoia: "e72409dad20cc84f167c0ab871ca99dd94be149506d08dd58bfbf0abacc106b8"
    sha256 cellar: :any, arm64_sonoma:  "674d7a44275e3a88767a5d24eafed059c6476dd63ad25fec7a87360f0b8c6bd4"
    sha256 cellar: :any, arm64_linux:   "a95849bfb2f93909e2653bb37ad6c59e45a51c62975dc3fd24f10de0c3e954a3"
    sha256 cellar: :any, x86_64_linux:  "690d4924828f06f4f3e3a9b8fba012d738ba3108d6f07183c2b38cab23bb6744"
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
