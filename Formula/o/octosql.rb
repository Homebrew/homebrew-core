class Octosql < Formula
  desc "SQL query tool to analyze data from different file formats and databases"
  homepage "https://github.com/cube2222/octosql/"
  url "https://github.com/cube2222/octosql/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "e22bdb710ca0609019b842df347990ff9aed4f3635f5308ff1acf50d093b7942"
  license "MPL-2.0"
  head "https://github.com/cube2222/octosql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c7a4f8a7b4ef2166c839bffed27d9f03cc461a397a9599a8a928d7aa13769578"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6fb02732ee419bd030f5b4114904f013d2cbcbf6a5972c7c180cc8b39b50218f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b90c0eb55eba76d94d9b74ed271cec24ece2f80626fbc8984fd89a5c3572fad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8756bbed1866ff4ec61d41c3fa9e311bc1363a92a1e5bb7bf8007f3dce1016f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "266cbff44daa602cb4e315ab346893ec6f1c9ff8988629d25146555a702599c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "15616e45d1f71f3adf387cccca95f024f6a47ebac1eb43cad2bcf4033ba86eca"
    sha256 cellar: :any_skip_relocation, ventura:        "599c917127678f30d18e2992c5e313c9551e088f6c91641f2d41887ff006b073"
    sha256 cellar: :any_skip_relocation, monterey:       "e66e8404c28c51cd31a53ce95ac96341355948d807b7ece05ec46aca7ea95ec3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2c74938cd61568c5b569d3f86a0077aa1b0893aee68a8320386c373046728952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d93635da70ab7707f9a337ce7d30badfaac5c31f3d2d40c55741cdd8ff3bf6ff"
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
