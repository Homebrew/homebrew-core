class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/v1.4.6.tar.gz"
  sha256 "6fe4e49b57c33774c36d2dfd18d60bdbde98a4d1cfd7c31904c16f5756f56f27"
  license "Apache-2.0"
  head "https://github.com/diesel-rs/diesel.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "591196c09f6b466667293f73bdce43feb651e03d37b68f2760b10a0210029b43"
    sha256 cellar: :any, big_sur:       "f33decdb3dbff3f44ab88cf933437deed70bfaaa52b934e7badec2f64073524a"
    sha256 cellar: :any, catalina:      "68886f00182c23bcb8e76e861e194292328fa185ef60ce5ba567c9c029061845"
    sha256 cellar: :any, mojave:        "3b680f376125f6e96f556e8ead859e1d5d0d081ea1dd5bbf3c61fd79e3976f1b"
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
