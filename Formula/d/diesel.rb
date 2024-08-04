class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "322d38d41077d393877afcff02f7ee3078ec2ffbe284af8a8a807d015f6efa9d"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "98b729ad5d58f9a6d768aa5acf0100fcdf19e7e0740de1b0882cc7870bec489b"
    sha256 cellar: :any,                 arm64_ventura:  "6ea5f1bc1c7a11bd34f4a04aa410d6c7e4c0a813371d1826eea336addc6418d0"
    sha256 cellar: :any,                 arm64_monterey: "b40a9173c1bf5f1cf0a60e3d5f617dd0c4b99a371dcf03f8a2cf6278d5298f57"
    sha256 cellar: :any,                 sonoma:         "9d5293df19fac39375d7a5af35791809d2a2fec02fa19ca140706f5dfd06ad49"
    sha256 cellar: :any,                 ventura:        "15d0d1b8f5cfb0006b6b83a4bb73927a126bcb3777ef98f79e29634c5ed4bb2d"
    sha256 cellar: :any,                 monterey:       "9051c01d8e4cacc468b03f5500b5bfe2e52bc1ac2dc508ab98342265e95e234b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db7738237e08a9d9deeea9e31a51698961381795a9f670c6a1e68aafa38038a9"
  end

  depends_on "rust" => [:build, :test]
  depends_on "libpq"
  depends_on "mysql-client@8.4"

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
