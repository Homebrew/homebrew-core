class Octosql < Formula
  desc "SQL query tool to analyze data from different file formats and databases"
  homepage "https://github.com/cube2222/octosql/"
  url "https://github.com/cube2222/octosql/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "733e7d066fb72867d32f1913e937ee3ab6830a991585ee6c232d211315b57c70"
  license "MPL-2.0"
  head "https://github.com/cube2222/octosql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f06ed08c993812025bbff7a882f3d56de9fc92c8f22df379410549c7dc623bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5a58e2557f45f531fc8c50aaad6692e58f52aac5716d5bb887c6a6fed16ee1d"
    sha256 cellar: :any_skip_relocation, monterey:       "d9e33a95899cb8550ef08b8a2bdd460e693ae2a0db9b36bab5548e1e912d8c5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2362edef5272b9a96223942ba3561f6e3c7d6c4c0623f3fc193611f79723b717"
    sha256 cellar: :any_skip_relocation, catalina:       "b3371299be8e66c74cb4b9f74abe889890eb4d9a8ca0c7d57d567862bbf0313c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5d273ecdb6a309f9596b4739e35a88cb58c40133e7b48b8b08b34c020ca3266"
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
