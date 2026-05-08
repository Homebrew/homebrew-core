class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.3.9.tar.gz"
  sha256 "3f1a42f0a9917d8b1efbcc2851af28b81ccf87f5fae3b2530890ca390ea68de9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "39f78a782269228dcef12d4920060c987fd2a1940d1996e794a4e97b67732d66"
    sha256 cellar: :any,                 arm64_sequoia: "50a68b79d7f1e7791da69bee493e64a6a56e3a878b24a1a9ca354f0d610ac017"
    sha256 cellar: :any,                 arm64_sonoma:  "d36554af9f0a8350895ca1977b1ee5304b87b90204eabc73c4c7aaf454996839"
    sha256 cellar: :any,                 sonoma:        "445f1093d2e477d94e60d9b90feade982cda49d51c1dc710d833a54805c8c827"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "436379da3c999e8fc5bc567b845e1fcef2ef298269a42403e64c56b63f837292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ad1bdd6f8e46ccec6b9883fe52be4048f7c817880e4d5b4cf5f003d92e67638"
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
