class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.3.10.tar.gz"
  sha256 "b52b018abbc27445de57b52f2d4edb6e92ae6b260aab032e0cc436f1f676aa04"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9d159d9635e0984baa5c0ce1ee44a69770dac33925270987b27f19108d488161"
    sha256 cellar: :any, arm64_sequoia: "7be247ef13c0f826b4da1b220237788fed50533698294916e97080978c3a130c"
    sha256 cellar: :any, arm64_sonoma:  "030c3f828f2f5ec7c7c5e1d479b6bb47372e689725d4dee381422a80dee3f904"
    sha256 cellar: :any, sonoma:        "bb0ae84fbe216d69bc65cb1dab2a2989e2a741dc5e8f1eab4a1b61a4e4dfb29c"
    sha256 cellar: :any, arm64_linux:   "4a1e13c3b0cee1ea83b4543b6868ad9a724055a74a4c6cf7deebbd7853e03358"
    sha256 cellar: :any, x86_64_linux:  "cdd53f2b0350adef92b687f27264eae39b5f1387245974c5eda4684c6e43f0da"
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
