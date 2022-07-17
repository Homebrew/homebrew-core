class Octosql < Formula
  desc "SQL query tool to analyze data from different file formats and databases"
  homepage "https://github.com/cube2222/octosql/"
  url "https://github.com/cube2222/octosql/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "128f9505d37a682193e6db4aa5424a1874fdb8d446c16dcbf08fc1c1bc1830c8"
  license "MPL-2.0"
  head "https://github.com/cube2222/octosql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edc95ebaaa7325aeb294feef1f3fe8aaf585dc8228f0a067cdb5b5c23ac78bcc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f245d262645200e5ad0825dfdc2448d05436b5d68d16cba7805e0ff7b3b4fb0b"
    sha256 cellar: :any_skip_relocation, monterey:       "2275264855241209c326b1aaf56b0a42ad3b33988233fddf33d6b107b1b4b6cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0a0a7f9451475c56ed08607671318c910f047459d50f5881275bd54dee445d7"
    sha256 cellar: :any_skip_relocation, catalina:       "f04b1b204be3f900c02efefa28ea6345ff2245db48bfcc26e4c4c539aefe755d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "253067363605f5d11f945f0e167a9547564b66176bbecca5052d6dd932e76d45"
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
