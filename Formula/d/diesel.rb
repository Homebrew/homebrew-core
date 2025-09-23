class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "defa918271f992188bb815b008cb3d8751fecca071b5f4e227ec03ebfb2e301e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc6ee890bbe63f5780ee0c0c3657d1c2bf383a34f8946f4e0d9c5d25aacea132"
    sha256 cellar: :any,                 arm64_sequoia: "fdbb2e8e3f889804b0cc2cf12201ea12226687413dc8fbbbb5bdaf44ec38413e"
    sha256 cellar: :any,                 arm64_sonoma:  "2d8dc2407888af4826269c69deb35f7d5172dae724c26e8aa4a61bd008dadb06"
    sha256 cellar: :any,                 sonoma:        "964c2a3a5026fe2e5fdc9007521912559e4f7da24012444defce33d797fa2ae3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d8aea5ad323ef9afd1200125168d78f32c15db0013b4e2b3b97d12c518aa0b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6721b1cdcaac03ce88e7f82082a7a3bcf84bbd9ac2def6f99ab97a4ffe16a66"
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
