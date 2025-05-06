class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.2.10.tar.gz"
  sha256 "7b2bad8963a8c0617b2d2259b2edeb34f10f36615b9a86e2a4a71546a13d7047"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "97bec8a3bf972ded46e195a7b61eba9e255224fd6fcc070c8a086cd4055729e5"
    sha256 cellar: :any,                 arm64_sonoma:  "30203072dc2ee0738bd3bc129f47b7684a168e309c78c1afbc9dbe3e47e5780f"
    sha256 cellar: :any,                 arm64_ventura: "a0c29e5dd9a63f3e906ddb6e12959e6ed5ce77c7e1b013b4cbfc31dce4500df5"
    sha256 cellar: :any,                 sonoma:        "dc260b121c3f39634c66a6dc74f6911290ed6d45565b4a35fa0f9fa829ebecfd"
    sha256 cellar: :any,                 ventura:       "ac6b6c4d5be5d8c6159c5cc8854cc4c105b5503507ad1612df2b01ae8f5f480c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05b025b705196626075a6526bd658bee80d9c685e200eba8f4dbfc92a31b0a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "637290663af15469c48782dfef35b6d7aca557c96be99e3be5988e8a9e23a919"
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
