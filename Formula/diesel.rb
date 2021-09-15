class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/v1.4.7.tar.gz"
  sha256 "5ed961b3f78b26427f8fceaa234d615d628dc3a18e5182ecdd9ce5af84ed2d90"
  license "Apache-2.0"
  head "https://github.com/diesel-rs/diesel.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7504ecbba4c99649dd56c2c0ac4df434a04251049d0364f685eec03165a1ee00"
    sha256 cellar: :any,                 big_sur:       "3d28f59de8c707d09adf14916802d0ddb8db59d54a0318e6fcbb99c53477f0da"
    sha256 cellar: :any,                 catalina:      "b63e15c3252fdc1907518309ab875447892ed03bd4de4a7853a0cee2f0284879"
    sha256 cellar: :any,                 mojave:        "9da02b6126a83dc9a80e994ae21c93e46b839d28d5b544fdda9cc64f8fb25dc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd50b0f715f7328561b9e81d97b4d305dc468d54896695f0444da8e727c57c4c"
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

    bash_output = Utils.safe_popen_read(bin/"diesel", "completions", "bash")
    (bash_completion/"diesel").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"diesel", "completions", "zsh")
    (zsh_completion/"_diesel").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"diesel", "completions", "fish")
    (fish_completion/"diesel.fish").write fish_output
  end

  test do
    ENV["DATABASE_URL"] = "db.sqlite"
    system "cargo", "init"
    system bin/"diesel", "setup"
    assert_predicate testpath/"db.sqlite", :exist?, "SQLite database should be created"
  end
end
