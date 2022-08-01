class Octosql < Formula
  desc "SQL query tool to analyze data from different file formats and databases"
  homepage "https://github.com/cube2222/octosql/"
  url "https://github.com/cube2222/octosql/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "7a239037794a28ede472c64027d20ec9d39aceec88241d13d4889b4778d09f90"
  license "MPL-2.0"
  head "https://github.com/cube2222/octosql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd19f7c814a516ff986edc2b0ec6b330236cd17b0dba8cf641d0aacfbad89d3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa9d2fa9c4deb89deed339d817df8e622ab66199cf4004fad178b2ab548d5664"
    sha256 cellar: :any_skip_relocation, monterey:       "167eebed9fa640d3cd8bd00b16cacdd47206d399a91a1c721f249ad97e2beae9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d5eedbe109786545d46106c02f40819f57eac1baea92cd42233dc75b7cfb048"
    sha256 cellar: :any_skip_relocation, catalina:       "ba615966dd4ae2d8f29ab76c5cc53893307f2ef30f92ef2b7f0a3c9832a25ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8c3917953eb22e8f4497de37862eaf1db5c6e07c509a4c7cf66c81973f5c534"
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
