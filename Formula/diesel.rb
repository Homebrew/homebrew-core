class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/v1.4.3.tar.gz"
  sha256 "79769964028e5cc85219d100d4945d69a5d2ec5a4125c36fd50b9ef1dc326d5a"

  head "https://github.com/diesel-rs/diesel.git"

  depends_on "rust" => [:build, :test]
  depends_on "libpq"
  depends_on "mysql-client"
  uses_from_macos "sqlite"

  def install
    system "cargo", "install", "--root", prefix, "--path", "diesel_cli"

    system "#{bin}/diesel completions bash > diesel.bash"
    system "#{bin}/diesel completions zsh > _diesel"
    system "#{bin}/diesel completions fish > diesel.fish"

    bash_completion.install "diesel.bash"
    zsh_completion.install "_diesel"
    fish_completion.install "diesel.fish"
  end

  test do
    ENV["DATABASE_URL"] = "db.sqlite"
    system "cargo", "init"
    system bin/"diesel", "setup"
    assert_predicate testpath/"db.sqlite", :exist?, "SQLite database should be created"
  end
end
