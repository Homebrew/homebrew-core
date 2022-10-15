class Octosql < Formula
  desc "SQL query tool to analyze data from different file formats and databases"
  homepage "https://github.com/cube2222/octosql/"
  url "https://github.com/cube2222/octosql/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "90b239cdc37574cb7db16def68012d090f1a8a26b9bb7385a182d92f97bbb9f7"
  license "MPL-2.0"
  head "https://github.com/cube2222/octosql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aeb56357efd27196be0ae5fd8d6a91c9a2bea63b54eeb969738acb875b2ba317"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5e14b1343d8883d367544ac11d2649e607df9cc534aa84176df1989c21ae7b2"
    sha256 cellar: :any_skip_relocation, monterey:       "9b3b20d538db2f7b48417442ce0f257a78d70ca8621dfb96745432c0c13776ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f9a257262020cc09f0e416fffcb03ddb76e190ebd7506974cb233cb8030977f"
    sha256 cellar: :any_skip_relocation, catalina:       "1b1ecc06ede0fc12e199ad21543f5d2ff020dfe72f6b526c307e7cd5474599dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7c043f1a76648e406353a3929294a74e4d04d03ec821535383aa67089a9f9ba"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cube2222/octosql/cmd.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"octosql", "completion")
  end

  test do
    ENV["OCTOSQL_NO_TELEMETRY"] = "1"

    test_json = testpath/"test.json"
    test_json.write <<~EOS
      {"field1": "value", "field2": 42, "field3": {"field4": "eulav", "field5": 24}}
      {"field1": "value", "field2": 42, "field3": {"field5": "eulav", "field6": "value"}}
    EOS

    expected = <<~EOS
      +---------+--------+--------------------------+
      | field1  | field2 |          field3          |
      +---------+--------+--------------------------+
      | 'value' |     42 | { <null>, 'eulav',       |
      |         |        | 'value' }                |
      | 'value' |     42 | { 'eulav', 24, <null> }  |
      +---------+--------+--------------------------+
    EOS

    assert_equal expected, shell_output("#{bin}/octosql \"select * from test.json\"")

    assert_match version.to_s, shell_output("#{bin}/octosql --version")
  end
end
