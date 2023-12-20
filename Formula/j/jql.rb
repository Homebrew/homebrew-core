class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v7.1.2.tar.gz"
  sha256 "88846ec9ca9eb075c44790581402eab93f0fa21df6f3255e1f13e3214911193b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "042ba8a55adab86e41fb58b20ba3fee01415384a8eb97c53ec567083b18d6b20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cc9690ebd27ce033c00050279a46c0cecd8a0ef67add26614899ce477aedd5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45afececd16fc3025d56a319b3ce6b6cb48db3ccc9b7d09c0c74da77e8b23ea2"
    sha256 cellar: :any_skip_relocation, sonoma:         "96f5b4928f2a1766739ccb8034d0c40967364b70e92edba5429d75db3604705a"
    sha256 cellar: :any_skip_relocation, ventura:        "1586ab40123156ce16a82f7cc06c4f20a2851537adcf7326cf9508c94ccb7a19"
    sha256 cellar: :any_skip_relocation, monterey:       "2951432c21d1b2967169c14757904f9683bf69869316d828f564ac5e60e7e6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e31a2018004133758d596279e454ffa37787a28819d63b6b1d8fcee63d6beb1"
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
