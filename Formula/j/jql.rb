class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v7.1.1.tar.gz"
  sha256 "01ace79082541cb3f555cb31c11fb156ce49451940e382edd59bf08c01f2df34"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4faf64916dfe8b0df3a07c5c634b69c2b5f0513f652bea6912b49c1614356af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a183b08525599335a2220e1d42a2986152dbcf7ada8bf5c9bccf3598b265d24b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db73bf1d403b419238aa59ccfe5191bc2e30a581f7f27fd41edc809bc3531147"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d717c6d6dba5dbc7407eff8098744d7986e76d962f4a390e68d6e5619c349be"
    sha256 cellar: :any_skip_relocation, ventura:        "94e8aefd8d1b7bd74ebc2a0bf00166a29aa1f6f8c99aa1b5bfb65be84ad61fbb"
    sha256 cellar: :any_skip_relocation, monterey:       "4b9a249ff9abf1d59e4b9ac55f113be8ab3565b16ae6ad9629c4d9a9b2d69413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67cdaa14f33087de1da3e2a6581acdca439bc511acc7c5a7a30d89a8454ccd30"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jql")
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --inline --raw-string '\"cats\" [2:1] [0]' example.json")
    assert_equal '{"third":"Misty"}', output.chomp
  end
end
