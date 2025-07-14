class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.2.12.tar.gz"
  sha256 "583f2d71a14b2bb318222474bd1f26f93e945a3e98dcf1b892c67463abe13897"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c1d432e2906544eb1c778d7a600c648ac8bbe6f7d184552dfb1e5037483a808d"
    sha256 cellar: :any,                 arm64_sonoma:  "ea7d5e7663e95e05fac2c0f9febb3f06c8d2ea6ae01c9e45e830422bc9518d3b"
    sha256 cellar: :any,                 arm64_ventura: "4efdee80dc2786ae276f3942e0afd28956770721938fd40db4413e4b8cc28805"
    sha256 cellar: :any,                 sonoma:        "38b3a3daf0c5aa396f2aff72d6c02f7a5a0ffcb6c3a690638a2369a664e48167"
    sha256 cellar: :any,                 ventura:       "3493c9508d3fcf55e8f64242dd23843bb37837d89ff03eeb8f6b4363d2426640"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54d452e7afae56304c1180ae1dec7de96569fdc26c53ee45f1fd9570cb4af62e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ff6d2f7204686a2c23d36b3ad64787a207c8a8885facc0e2cfb5a52b4dde446"
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
    system "cargo", "init"
    system bin/"diesel", "setup"
    assert_path_exists testpath/"db.sqlite", "SQLite database should be created"
  end
end
