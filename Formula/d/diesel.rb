class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.3.7.tar.gz"
  sha256 "18dde504d882a7d9c72e38ad960cc4a0482eb2a39f43c0c2274953dae8f95616"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c1f1c9cab255fee784506dcb916ea5c97346b13159a98d6be2afe4809d65dd7c"
    sha256 cellar: :any,                 arm64_sequoia: "921154ebcda7421e89fc0543d1cee2a11d4022a00e4dbad09363b9b618c1ca3d"
    sha256 cellar: :any,                 arm64_sonoma:  "2f4394c22dfe78e85d7255c40eadc4c6d373024e0a182909e6c0445220c32bb5"
    sha256 cellar: :any,                 sonoma:        "d61909a2dfa663fdafc40a03ca2f1ad2f066a1cdc2a543e233e2c598ece2799b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24d8ac3184d827b33b3ae457f55c4952d17101ea7e2f6e675ba3fa78afa12a1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5ec14987a0ee90f246bff260aadc4d135dfeee79d3f56d9d71a8785f0bfea03"
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
