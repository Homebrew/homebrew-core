class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v7.1.8.tar.gz"
  sha256 "d678a72bd5949a7eadb7952e62bd37d450c886e7f9e0e47bcd32c23d1f2becd9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6c8647db2d862e272bc66134aa3d87b5de1dcfbf7b43fc7842dfb6313949b6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "472562a2bca1ec12ada6b315fc410d54f2f97e2f302eef052bd98879dd65385d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "832304bb5e0a86a73cbaeac724a81606698162391cd0b67f75fad45a060e8729"
    sha256 cellar: :any_skip_relocation, sonoma:         "122151a540993debcbb23eadd8b2cadfc6f8f39c8be69a1ccf1570b75fe87ca4"
    sha256 cellar: :any_skip_relocation, ventura:        "9e4c626063f2560fb4b186458425a942fd6d51bb618393f2a739d4697ce7675a"
    sha256 cellar: :any_skip_relocation, monterey:       "a81cee70b568320f34721e87e3abf80a6c3c85ac1916a01abe422cc79a0306e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3d39a7272f98fd38dcf775463ae6c1545889aa156e91c63a197165b8bcd92ed"
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
