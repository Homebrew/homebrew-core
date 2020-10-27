class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/v1.4.5.tar.gz"
  sha256 "cb034b398c664523f5d822a240f645a7a0fcc63de668acc9aa12e1d2aada470d"
  license "Apache-2.0"
  head "https://github.com/diesel-rs/diesel.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a63b7299a7b32a4c6f581ce4aac9b264bb4b1fbd555268126f2db791606846f2" => :catalina
    sha256 "ecff18f1ca293e846f0a1742311c89a146315a051531a3fff6ff27ddb14f9e95" => :mojave
    sha256 "f63d5ac49ce152f424ce1d0072177857a0c9724156bdb5faad34f74af58e24e6" => :high_sierra
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
