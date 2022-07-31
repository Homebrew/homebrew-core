class Octosql < Formula
  desc "SQL query tool to analyze data from different file formats and databases"
  homepage "https://github.com/cube2222/octosql/"
  url "https://github.com/cube2222/octosql/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "7a239037794a28ede472c64027d20ec9d39aceec88241d13d4889b4778d09f90"
  license "MPL-2.0"
  head "https://github.com/cube2222/octosql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4903d3cb0843744c0fb557e1b5d6cbb4b252d8bb435ade2fbef6f848fb33317"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8a4a8fe273a4282c0ffa621d9628b98f220c33c2b7f59915452644a27fee309"
    sha256 cellar: :any_skip_relocation, monterey:       "ed070cf7a0bbc69a8c424a3b244fc6570c6c9806fcadb5df3cdb2bead43b4034"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9215b5b56cf9ef8435a846749796fe26a62b3a5f6142fdb172bfa764987c025"
    sha256 cellar: :any_skip_relocation, catalina:       "bb67990fb928b7cbfa02075403ba2772df76382e584fa9ba231667106e53781c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c0f02f9c03b423f2864cd024c16933263271b8d3b7db12462bff51d6eed04fd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cube2222/octosql/cmd.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_output = Utils.safe_popen_read(bin/"octosql", "completion", "bash")
    (bash_completion/"octosql").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"octosql", "completion", "zsh")
    (zsh_completion/"_octosql").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"octosql", "completion", "fish")
    (fish_completion/"octosql.fish").write fish_output
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
