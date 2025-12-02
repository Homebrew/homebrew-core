class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "67f8109ce5e62259e540f98885d41e5fa5a44722af8f83a0256eda3c92175b76"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2d74f027819bc980ea1569796d5fc77148f997e01723e6b12e1af0501eff159a"
    sha256 cellar: :any,                 arm64_sequoia: "767354256c10b6ab236d6f7e120e41099571facfcbf1db6984e466ecc782419f"
    sha256 cellar: :any,                 arm64_sonoma:  "c3e5bc84046ad2ed550f045322cd86bbf7abbcb5351c3643f58009229355eefb"
    sha256 cellar: :any,                 sonoma:        "d32602fcc0b51b911c8903b0db0a4e33e3b141717415a4208f74dceca3d03373"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "743f4612208a9f01093687c49bb612e70f79bf8c00412260972076f015219c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "087feb936b4736004f77d71c61225eaac48b7b7f3d02b20afe4e33b080542d82"
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
