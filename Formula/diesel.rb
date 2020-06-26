class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/v1.4.5.tar.gz"
  sha256 "cb034b398c664523f5d822a240f645a7a0fcc63de668acc9aa12e1d2aada470d"
  head "https://github.com/diesel-rs/diesel.git"

  bottle do
    cellar :any
    sha256 "ac45d9f820900b225514e4be60f1dc464bcfbbe761dc859c0819251bd1b14cdd" => :catalina
    sha256 "3c7b792fc6a675e7024fcc5fc476f73acf4f4a905a3daf0e123c013a7e5d9fa5" => :mojave
    sha256 "dc19ce6a50fe00903838cfea5135840db899a04cb0176d053343a23b8aad749c" => :high_sierra
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
