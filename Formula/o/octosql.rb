class Octosql < Formula
  desc "SQL query tool to analyze data from different file formats and databases"
  homepage "https://github.com/cube2222/octosql/"
  url "https://github.com/cube2222/octosql/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "e22bdb710ca0609019b842df347990ff9aed4f3635f5308ff1acf50d093b7942"
  license "MPL-2.0"
  head "https://github.com/cube2222/octosql.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c72a70690339c26059914fd99ec9e7ebc9b35b828ee6c07cbdde7af8bc1f7e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c72a70690339c26059914fd99ec9e7ebc9b35b828ee6c07cbdde7af8bc1f7e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c72a70690339c26059914fd99ec9e7ebc9b35b828ee6c07cbdde7af8bc1f7e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8aeea6a96ae461bec7631704def7cf422a25fcc2f433ac18e801e1ceac5d67a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9bcc6b096962d539dce6ae887259710127684f4246ecc5136f34fc4027dd263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0756a2f3337b46a79897beaf2b080ffd1888c648e87751fedd999c7002c5937"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cube2222/octosql/cmd.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"octosql", shell_parameter_format: :cobra)
  end

  test do
    ENV["OCTOSQL_NO_TELEMETRY"] = "1"

    test_json = testpath/"test.json"
    test_json.write <<~JSON
      {"field1": "value", "field2": 42, "field3": {"field4": "eulav", "field5": 24}}
      {"field1": "value", "field2": 42, "field3": {"field5": "eulav", "field6": "value"}}
    JSON

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
