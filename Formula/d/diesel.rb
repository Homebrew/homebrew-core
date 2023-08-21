class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/v2.1.0.tar.gz"
  sha256 "0c530935a45876006417e8c9668088de7bd7445e8846ea859ea66f98d6e667cd"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae9f25685b3bb5064b962b3df8e699b5ff9a0f9693fe2cddaf19826488ce3d8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "492d021b27025109291073948d5b24ebd574f6306e44b37f713faf386d0f0bdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35f081263675ff1b482ee54ea026aefbe3463c26c7d97d8d8779830e2fc76a95"
    sha256 cellar: :any_skip_relocation, ventura:        "39f20e05f7080d70635887e917852af3c2642b3bcb4209d3f6746bea39aad8d1"
    sha256 cellar: :any_skip_relocation, monterey:       "efad1c961a2684a88e360defe5d48b16eb4b72e548006f3191271cea6ede46cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "6451017a4f456b3baed26f2cf9fbb3a057f8a65b978c3866c63cb2f1a6b504c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6310c2b9bfd4855ba8c47396862a723b6cf6430c64b67ed90564041d64867f08"
  end

  depends_on "rust" => [:build, :test]
  depends_on "libpq"
  depends_on "mysql-client"

  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args(path: "diesel_cli")
    generate_completions_from_executable(bin/"diesel", "completions")
  end

  test do
    ENV["DATABASE_URL"] = "db.sqlite"
    system "cargo", "init"
    system bin/"diesel", "setup"
    assert_predicate testpath/"db.sqlite", :exist?, "SQLite database should be created"
  end
end
