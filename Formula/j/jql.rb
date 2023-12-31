class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v7.1.2.tar.gz"
  sha256 "88846ec9ca9eb075c44790581402eab93f0fa21df6f3255e1f13e3214911193b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fdf7728b5d681d0dfa32dadc018b5b9fbdef4e6ef42e4a257f85ba6a3cf10da5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdb760162614a55c85c59ef41d78f131dc4c8df407d208cac75d938d7fe5a7df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2415e328da22182ed0af581f9ac6a68d5e0a67ddffb52783a98e1f563ebbdf79"
    sha256 cellar: :any_skip_relocation, sonoma:         "b556af3a19ad37153bdacbd408826ba06922561127bc84a173a68cd27abb82ba"
    sha256 cellar: :any_skip_relocation, ventura:        "611e9eacb22d9167de150e8e103909bc72a9c037cc34745a652e7d5c1f925c39"
    sha256 cellar: :any_skip_relocation, monterey:       "eaa361798c1d1fa590cf779c59cf26242dfccf5c8b1ae5102cd876b9d0ac1db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61012f7601c78e854bd9455e40c265f36da9d7697571a4e6aab530404eda3846"
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
