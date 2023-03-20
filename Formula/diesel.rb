class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/v2.0.3.tar.gz"
  sha256 "83012e6ced6349923e487af837f222630d43ffb98962a6be60fe7f5a63874be0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9bd06313de12df90154f96ed9311db56de5a446c2d7252247bee4e2397a2ef61"
    sha256 cellar: :any,                 arm64_monterey: "a77c958dbac820081c59906e1701c644448252d5a38f784ba8702ac65fc2b265"
    sha256 cellar: :any,                 arm64_big_sur:  "20bc84154eadbcaf44381f1e9e54bd56b77a90ce1223120e68ec51fc903e233f"
    sha256 cellar: :any,                 ventura:        "ed638384944cae8ec4c9fea5b7c8841b81265b790581207ad70dc9be9b8430f4"
    sha256 cellar: :any,                 monterey:       "3c64ceeb9f857809cbf88b5f9c2f54460181ee6210a022b3813f6a6f2812963e"
    sha256 cellar: :any,                 big_sur:        "26fcd4600843f3e05fbdd9cf44178c8b2498d6724c8915aa5a97b4d808498c73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c409d05e9ac6c034979bbe5e9e944266789666feccbd18c3f9877b8f4dc69915"
  end

  depends_on "rust" => [:build, :test]
  depends_on "libpq"
  depends_on "mysql-client"

  uses_from_macos "sqlite"

  def install
    # Fix compile on newer Rust.
    # Remove with 1.5.x.
    ENV["RUSTFLAGS"] = "--cap-lints allow"

    cd "diesel_cli" do
      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin/"diesel", "completions")
  end

  test do
    ENV["DATABASE_URL"] = "db.sqlite"
    system "cargo", "init"
    system bin/"diesel", "setup"
    assert_predicate testpath/"db.sqlite", :exist?, "SQLite database should be created"
  end
end
