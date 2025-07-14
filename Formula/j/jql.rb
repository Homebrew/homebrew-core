class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v8.0.7.tar.gz"
  sha256 "05448d17d1036373633e0d6a4556481ccc3b309832bdc9363d4c6f5d9d4311a4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "910e6bfa669d89502d5813e35f08c35045900781c753e8038edb598ea1b4a111"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4281cfe8a31d137ae341e2121c662f113787779bb51f188c3203ef0c88ec570"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4dfe01a97571a5588a076c9bec4f1c97d5931fc8c9955f2a6edcb778ff252f5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5183bb93a90a40b6c0a49c27733e08a57bd7fd46ce9899d7141c5f2ab795539"
    sha256 cellar: :any_skip_relocation, ventura:       "cb9f39ccca3db2e3a96606edf6d26f229fd915dfb5f7d1653da42e922380f2ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cc9c62b4d9990433b28b5e77e8de4985b7c1e23edd54f39f93619072ae65c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc7aa94d5c2f521c2aedefa9eccffc92df462287c74f96aae29388e3822e1530"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jql")
  end

  test do
    (testpath/"example.json").write <<~JSON
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    JSON
    output = shell_output("#{bin}/jql --inline --raw-string '\"cats\" [2:1] [0]' example.json")
    assert_equal '{"third":"Misty"}', output.chomp
  end
end
