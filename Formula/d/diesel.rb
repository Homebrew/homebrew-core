class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.3.12.tar.gz"
  sha256 "4645dbf5a7d5bb6d224b9867dc91f7f92e54ddf722671612643cdfa98cd5c557"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "32158dfcda48abdc0a6f3b88851f3da557cc3bdadd5189521f9cf4bdac3d30e8"
    sha256 cellar: :any, arm64_sequoia: "c7a0c9711a5f55d205396c9b0f462fb3ee553fce8b64d49d35bdbdacd085ed41"
    sha256 cellar: :any, arm64_sonoma:  "21c0f8a0a66492fd2776d845f1a9e331b9f2b6b963c9e74e6fc72b92d6c8b729"
    sha256 cellar: :any, sonoma:        "a363c725808cdcff034f049ca21851ec3d4ee084b4f2176230d2b1dd68334d9e"
    sha256 cellar: :any, arm64_linux:   "17a0642bd5f3baba5d76175add38ac0628b41bee6453f56b0db2477ada23aa38"
    sha256 cellar: :any, x86_64_linux:  "c467e9656b8df8672115a872c65c816711f6224778e0b7af9b37fea0cf9d6872"
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
