class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/v1.4.4.tar.gz"
  sha256 "e3f80fbc31d3233821f90f6830750373810ddb739f2300c94cf68b342e6bcacb"
  head "https://github.com/diesel-rs/diesel.git"

  bottle do
    cellar :any
    sha256 "0ec3b3e14f123c80b4ad66ae4ca3f157466816851b888e87b510a9d963eae55c" => :catalina
    sha256 "3bb69602a4de796c29d7307b9d1ad743bec7b92566d9c5ccab49f625f0c3a45d" => :mojave
    sha256 "5654e9d9fe8a8fef958f9db3efe93d007dce571cb3a30ee81443c8608e5864c3" => :high_sierra
  end

  depends_on "rust" => [:build, :test]
  depends_on "libpq"
  depends_on "mysql-client"

  uses_from_macos "sqlite"

  def install
    # Fix compile on newer Rust.
    # Remove with 1.5.x.
    ENV["RUSTFLAGS"] = "--cap-lints allow"

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
