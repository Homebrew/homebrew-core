class Octosql < Formula
  desc "SQL query tool to analyze data from different file formats and databases"
  homepage "https://github.com/cube2222/octosql/"
  url "https://github.com/cube2222/octosql/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "31d5d37948fd6206c68a6163c5d91e4f99ba0bda362816a0018279f947d1ff37"
  license "MPL-2.0"
  head "https://github.com/cube2222/octosql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb01845a33431e8b0ccc3e6c7913341347d9116c2facb0473746f180702321b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "635e89addfb8ad8712858ad53955c96920c1def582f5027b7b38bf3b15a2f862"
    sha256 cellar: :any_skip_relocation, monterey:       "ee6cf273a562a9aa42d1b7dc06cf0c8d84628d7c6313aaae94aa20423417d244"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8dfb66ee3b61cbca2e943d1a1fbf782bce619d82ddf61fc56b2877beee95eae"
    sha256 cellar: :any_skip_relocation, catalina:       "9f5941ab3ce494840c1d8c5d5850ad3951be3ef2e3a3cae13c9c0e550027114a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a583135ce1753863e82e779b40446b4687559b20dbafbea6401d1c2e1605e50"
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
