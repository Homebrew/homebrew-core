class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/v2.0.1.tar.gz"
  sha256 "b425d5f5c95e7c70fbd43b9e15a7f4a97cfd41625cc236072d86c4bd104c9a4a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ff6e40e21b2e066dce4fcdd5ab49006d3e6ca3350f09ad98124e3c97a71ceecd"
    sha256 cellar: :any,                 arm64_big_sur:  "fe13ac2924e33651104e1aead669dcb279d9b8a2ebe91b7569b570b0b75ab69e"
    sha256 cellar: :any,                 monterey:       "1d1a7eded645e144c881a2e73fbef512cbd554b9829c110f781a03377340229d"
    sha256 cellar: :any,                 big_sur:        "484d3f8531ee6d4d5ba046dfc2fe5f65ed1f72b8665bdcc49f924b83352c1313"
    sha256 cellar: :any,                 catalina:       "5402a7ba4a66129fa75951d5770307ca8b6e5de21737d4ff7aa24574c8a35f9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09a5b484bbe79e8fb5937f2e1a35032ad064a7271ef84748c683e4f298370d54"
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
