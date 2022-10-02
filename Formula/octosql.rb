class Octosql < Formula
  desc "SQL query tool to analyze data from different file formats and databases"
  homepage "https://github.com/cube2222/octosql/"
  url "https://github.com/cube2222/octosql/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "7c891953d0e4a286a04ac7cf92a6524493de061f1ad45c3c7a9fc85a7b170558"
  license "MPL-2.0"
  head "https://github.com/cube2222/octosql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5609a5dd80d46373e71b3b016ef5ec8a103b6d4d425a3d8a60647307bcdaf2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d405b80460012d997ad3c4097bb7b55cd43bcbbd6ac7e3b5b2108edb6444db23"
    sha256 cellar: :any_skip_relocation, monterey:       "0b08753cf0d0c71e0e8cb8d644cebfa1a1a031568f746681e84643caac63fdb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4aa7dac81224f7dc791b2fb75cf9da827764d3a9c4c5290b5bcf9c9d7a100cc2"
    sha256 cellar: :any_skip_relocation, catalina:       "691d4b3ddb2516cdfbe5fefe6307784659d496c442ad36f19f51578205615e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4162be66917782003aee1e12015a324f2cab437fb223ca9b1e892eda3a14d442"
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
