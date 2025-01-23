class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "55244c993f4fee5e2c6af4810744d0e604cf781efd71953e98baba4fd5a28a31"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fc4a4e3b249d9cd9479772462ab78c3737e361099b6d64c117cec125e0a70799"
    sha256 cellar: :any,                 arm64_sonoma:  "2d44c4324e2e185d85ca5f710a94b16638b7431e721ca3608a83727eb7d6a53a"
    sha256 cellar: :any,                 arm64_ventura: "6cafa4900ee1a4b4dfb809bab026d6614576d1458714980ec852383f78104d9d"
    sha256 cellar: :any,                 sonoma:        "4ce0b93ce2b18888008cc095e6fe76362f26b1ae96632d44133ec9ddfdb8a9f8"
    sha256 cellar: :any,                 ventura:       "1f4e88ad6dfaa15a83e92f3bdc75d4e9b8c4ad5f83ac75141ffc902a212578d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43e19ae62eab9b6525d4562d02c85f10dff9a5aa6df74ed0b9e11efa1e4284a4"
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
    assert_predicate testpath/"db.sqlite", :exist?, "SQLite database should be created"
  end
end
