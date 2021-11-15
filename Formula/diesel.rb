class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/v1.4.8.tar.gz"
  sha256 "229b40ba777c2728430112c6e89d591a62198851890b2d0a5cab3472effba240"
  license "Apache-2.0"
  head "https://github.com/diesel-rs/diesel.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "85be5b41c363303961b15c603535645e6b96e4824224431d08b50f668ea35aa6"
    sha256 cellar: :any,                 arm64_big_sur:  "946e0f91a7b7875896da35c0f083364f86dfc64a963404e4d7472696930239ca"
    sha256 cellar: :any,                 monterey:       "9bc1ce226717ad9d91ab10488d1dc1ec3d2e63d6a79e3ec8f8bbf21dbfe3afcc"
    sha256 cellar: :any,                 big_sur:        "6e53b553c0e0db9747c2dcb8e473e3ce5bb703fabe0be39e9246fa6245691cff"
    sha256 cellar: :any,                 catalina:       "a4d7074376cedc36497448056e42bd91e8afc5ac3b6fc754f2ec210fb96f950d"
    sha256 cellar: :any,                 mojave:         "8d0339a55ef1391da4d3a88627f46055b9fd4f08b1cc911e20de2a7eeb7f2681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6710efd9946f769dc65df35aa1c3e14e38757ad2fd16b3fbe9243fb4a96e4766"
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

    bash_output = Utils.safe_popen_read(bin/"diesel", "completions", "bash")
    (bash_completion/"diesel").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"diesel", "completions", "zsh")
    (zsh_completion/"_diesel").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"diesel", "completions", "fish")
    (fish_completion/"diesel.fish").write fish_output
  end

  test do
    ENV["DATABASE_URL"] = "db.sqlite"
    system "cargo", "init"
    system bin/"diesel", "setup"
    assert_predicate testpath/"db.sqlite", :exist?, "SQLite database should be created"
  end
end
