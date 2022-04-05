class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.2.3.tar.gz"
  sha256 "7eaca4c04231c7b1a21cc86daf2cc4c0e2198275a098f46ba123e64742bc99b1"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ea4e178bfbb52a8e12ca0a984da53e517318a57c1280a2de89eeb3e38cd477c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "070da2bbed03ad7f58fa1845768dd1e62661ba0d7947f394d67eba90e9e70869"
    sha256 cellar: :any_skip_relocation, monterey:       "31f130f2adf2c9cb8fbb56ed1478b1eb048085bc6db2064a3724f305196b6ccd"
    sha256 cellar: :any_skip_relocation, big_sur:        "34200785f5f38b5ca32fe419b8b7f59c2fe5171652170608f2a7da039912f56a"
    sha256 cellar: :any_skip_relocation, catalina:       "41ff03ce91b5cbf0e4b42f3b3030dc5c754ef83a13814086693db41b848386d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e7bf69c170de8664dfc9b705c8d335eef0b2576783457f598f30378b68b439c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --raw-output '\"cats\".[2:1].[0].\"third\"' example.json")
    assert_equal "Misty\n", output
  end
end
