class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/refs/tags/v2.3.6.tar.gz"
  sha256 "83e5092dfcbbc4b45af42b6516b72ceeca8c7a4f3c64558d4177fb490d610db7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "37a1422a47206ba830b99bd09cccf6b7125b1f9685726235516ae4734be9e911"
    sha256 cellar: :any,                 arm64_sequoia: "a6679308bdc2113f77acd8029490f2667a3689131c450c3d3c54a628cbb1c5f1"
    sha256 cellar: :any,                 arm64_sonoma:  "287f81c4e14e37ced88b06329baaffe9e9d506dbf95cd78adc22b8df38a6eda5"
    sha256 cellar: :any,                 sonoma:        "5dc92c115496af0a341643c05110a9c8b9be0420f98df5041c38569467c9d19a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7adcde0814692ab9560a8b9ccea883584bbe395685180694bb96974079a407b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75ac078526a9aa18442b53138d18e84d596810fc52cac7cb6a4c1957e6d4a102"
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
