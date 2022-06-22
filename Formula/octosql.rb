class Octosql < Formula
  desc "SQL query tool to analyze data from different file formats and databases"
  homepage "https://github.com/cube2222/octosql/"
  url "https://github.com/cube2222/octosql/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "f6e7a6b091c88638c59fba80152f3a2efece3d8f79e49e7d398b763eea5b3176"
  license "MPL-2.0"
  head "https://github.com/cube2222/octosql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9641fc0f86cfa01cd6ce34d0fc137ed432b8bfef5f1bbf7bc90cef34f2a1bf03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26c5ee63019e395a53c8420247b6ed55583ea453f2893c5be31fde2af11f6194"
    sha256 cellar: :any_skip_relocation, monterey:       "96d1ebf67c88226704dc5cc337b539270355def75cd9c179ff177c684a3822fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7df9f7303a5e4542252d18bfcec99078ca2d1403efc1ef61d9b1a8ba589afab"
    sha256 cellar: :any_skip_relocation, catalina:       "576e365db9a507f1ecdab95eaf91b10d5a3ebb290965080847bfe0dccedb6fa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "291308631024d6a002188aef28099344d1cc9a97f3158a62c3006b5c0a29997e"
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
      +-------------+-------------+--------------------------+
      | test.field1 | test.field2 |       test.field3        |
      +-------------+-------------+--------------------------+
      | 'value'     |          42 | { <null>, 'eulav',       |
      |             |             | 'value' }                |
      | 'value'     |          42 | { 'eulav', 24, <null> }  |
      +-------------+-------------+--------------------------+
    EOS

    assert_equal expected, shell_output("#{bin}/octosql \"select * from test.json\"")

    assert_match version.to_s, shell_output("#{bin}/octosql --version")
  end
end
