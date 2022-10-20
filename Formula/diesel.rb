class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/v2.0.2.tar.gz"
  sha256 "d92d893849ebbd8e81e88a13d757e8273beac13c727fd34bfad20f986d03456a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4528a0b7dbb7d1624cf60238d51d374d4827306da7130b4b8b1e93acb7947e36"
    sha256 cellar: :any,                 arm64_big_sur:  "452a0801f5de9d2ccbf2f6a052e17b07739f63bd7bc18101a83968571d2f7fcc"
    sha256 cellar: :any,                 monterey:       "110629338b3ed4515ee8c7badeb95bc54eb68e8f23d22349bb6394ca90eb45f9"
    sha256 cellar: :any,                 big_sur:        "3150d85a11d0f586b35fbcfb2d4419ebd348d79a259991a9bab4d25bf2f2e4f7"
    sha256 cellar: :any,                 catalina:       "e7de1775e4f733a6223307e3c04b4ec9ec0db3c040fb14f58abf3489d8660788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db9d382a7b1453ef2cf5b9f6c5cabbb49125cba5aa275e94f837cae5a53161a4"
  end

  depends_on "rust" => [:build, :test]
  depends_on "libpq"
  depends_on "mysql-client"

  uses_from_macos "sqlite"

  def install
    # Fix compile on newer Rust.
    # Remove with 1.5.x.
    ENV["RUSTFLAGS"] = "--cap-lints allow"

    cd "diesel_cli" do
      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin/"diesel", "completions")
  end

  test do
    ENV["DATABASE_URL"] = "db.sqlite"
    system "cargo", "init"
    system bin/"diesel", "setup"
    assert_predicate testpath/"db.sqlite", :exist?, "SQLite database should be created"
  end
end
