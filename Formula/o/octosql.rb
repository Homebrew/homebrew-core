class Octosql < Formula
  desc "SQL query tool to analyze data from different file formats and databases"
  homepage "https://github.com/cube2222/octosql/"
  url "https://github.com/cube2222/octosql/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "e2bf45a039d1f6bedfd900b656a42ee3986c5a27ddae1a083f2dc52011c3b401"
  license "MPL-2.0"
  head "https://github.com/cube2222/octosql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1d7b2de7b5b4a77996caac3fde9a67389f9a44fe334764a028b7af9fc85328c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab15fc0d6bd735e1759005897c937cb8ba810793d1508224923404319f8b1e12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab15fc0d6bd735e1759005897c937cb8ba810793d1508224923404319f8b1e12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab15fc0d6bd735e1759005897c937cb8ba810793d1508224923404319f8b1e12"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b44ca11a3a0f74684fbd0da79240f6d37eb4f9b2425ed465993998a1c695b4f"
    sha256 cellar: :any_skip_relocation, ventura:        "588d02eba041ad5bfbd774d3fb490cd5994e0b85aab64921dc048d53f1eb8705"
    sha256 cellar: :any_skip_relocation, monterey:       "588d02eba041ad5bfbd774d3fb490cd5994e0b85aab64921dc048d53f1eb8705"
    sha256 cellar: :any_skip_relocation, big_sur:        "588d02eba041ad5bfbd774d3fb490cd5994e0b85aab64921dc048d53f1eb8705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cd6c3302ec6f8a7ef8ce30631b3bc03969c8a63f5b5c7412d33b6f8c73f2f7c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cube2222/octosql/cmd.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:)

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
