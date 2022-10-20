class Octosql < Formula
  desc "SQL query tool to analyze data from different file formats and databases"
  homepage "https://github.com/cube2222/octosql/"
  url "https://github.com/cube2222/octosql/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "046f31f1f8e4fc8dbc7c5e5769dae2a1dd249e7f96e61ef30ea1205921afa986"
  license "MPL-2.0"
  head "https://github.com/cube2222/octosql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f32a72383764f82a80daa0eb46a5c2b589934ecfece3c73580f0ceae1f70e74f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb97184600cab84a0fc661efd63ab134d9ae95464ffba4d4cf5670ab92bc9c24"
    sha256 cellar: :any_skip_relocation, monterey:       "8988b722768c5b196f3a50542f5c22d9689c0afbb4eb52f112e182167c252dbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ea43009b3c70c8b85b78cb0210d8056bafa97fbba15065cace4b42cd331093f"
    sha256 cellar: :any_skip_relocation, catalina:       "280c7b14d1a91c57df5fa0b4c4115bf4d7cdee9fd10e0509bb08b7320e33fc4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87bca2a8b9f6e9d477a797fcfb9cd9e32cbfb73d86b1e9b39c7e26a179e55661"
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
