class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.3.11.tar.gz"
  sha256 "409298c05178ae0520dcbb3878292599e0c7dbb7a088f6f77b649a8fa5dc91c6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "da3159c236bc1e15a49dae6c6e6055042f9d91018b985680f65d7da60eacdd07"
    sha256 cellar: :any, arm64_sequoia: "7b0e6cff32c6f60e2833fc18e1b2191be7676a50d950caa0aa8decd79d11a30a"
    sha256 cellar: :any, arm64_sonoma:  "f201a6e16887d1ee37e9251c31bb8bff4a606b8ca4da31e5bd271df370d15985"
    sha256 cellar: :any, sonoma:        "e7b58e79b3777f05908281ee99faf05ef79666204acaf6477b74eb9b206cae82"
    sha256 cellar: :any, arm64_linux:   "f596879e78ef8c8c265611d4a8aa2338b6c34a63c1d61a35c5a1841f71cd6493"
    sha256 cellar: :any, x86_64_linux:  "b538ac430513439b0aa83aa987be1451c0f8e2487c17137f3e60cd55f43c65d1"
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
