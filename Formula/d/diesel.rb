class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "eaed2b94bac9d93b5138cabcce45dab3bfbdfe9d2b911653c6c4571b45d8c9fa"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acbf79a7e8f09fd2ee2165d210fcbd243c8d9c257fab071dbc6ea53766054fc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fccc247b92f9991d1e24d8b6fbc1a1fd6d19970c60229c6a326e75a7d8e80f3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "558b3918ca0dfb19729286bc2939b093498dd0cedc13edf7d8c9badfe75e053f"
    sha256 cellar: :any_skip_relocation, ventura:        "fdd895a8cbf5afc39ba5d07e180706f95deb4204087eff55f675f1770e72a644"
    sha256 cellar: :any_skip_relocation, monterey:       "b2f02564df1c223d5f5acad65cfaf88bc4417c8ff714a541ae9209b849375da5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b98e2280d3c980181df23c7608acfb03533b2fdac2ecd7b9c9c6e98f4a3b3a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d268da02aebb441c2934e880cd57eea1cd826c45822231096338efc6cf5f4a2"
  end

  depends_on "rust" => [:build, :test]
  depends_on "libpq"
  depends_on "mysql-client"

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
