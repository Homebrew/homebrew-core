class Octosql < Formula
  desc "SQL query tool to analyze data from different file formats and databases"
  homepage "https://github.com/cube2222/octosql/"
  url "https://github.com/cube2222/octosql/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "408e0f5d7bfd9f8e7903ce1d6c55214e0c22c4d5c2b84195139afc0c12ac9fa7"
  license "MPL-2.0"
  head "https://github.com/cube2222/octosql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5e82c0efe3f4a270645266a48e8e16931ecb28ec529e04329a08ba3b375f35a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5e82c0efe3f4a270645266a48e8e16931ecb28ec529e04329a08ba3b375f35a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5e82c0efe3f4a270645266a48e8e16931ecb28ec529e04329a08ba3b375f35a"
    sha256 cellar: :any_skip_relocation, ventura:        "c5e2e135184eaa7f0d9100b81481c101c7a47a6f8fa65ef28e406948ea2a9333"
    sha256 cellar: :any_skip_relocation, monterey:       "c5e2e135184eaa7f0d9100b81481c101c7a47a6f8fa65ef28e406948ea2a9333"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5e2e135184eaa7f0d9100b81481c101c7a47a6f8fa65ef28e406948ea2a9333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86288065c44f12feabacda45e376cd2dbc3926b1e9cce8bdd0e145c7f8e23d93"
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
