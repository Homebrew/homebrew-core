class Octosql < Formula
  desc "SQL query tool to analyze data from different file formats and databases"
  homepage "https://github.com/cube2222/octosql/"
  url "https://github.com/cube2222/octosql/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "f6e7a6b091c88638c59fba80152f3a2efece3d8f79e49e7d398b763eea5b3176"
  license "MPL-2.0"
  head "https://github.com/cube2222/octosql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddc330cf3bad1449a8965e808a419ec462af496b46c69bc1c86bbe8d6d1dbb40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "890541c741e0ba61271d3486e0af9b66e750381cac94dc2c2aed0845e5e99a80"
    sha256 cellar: :any_skip_relocation, monterey:       "9a490abe06093ec681501bf6746cdf94e9bfb0bbb2b81ebb40efe12a72fbca3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b03c60abaf7291650743ae6a9d9e014d378592a33ffb0a19e9b0a6cf5bd40c1"
    sha256 cellar: :any_skip_relocation, catalina:       "97ab4a6adb7c0ef29fe792044ba70ff0858f009b77a4d23cf9415f1943a4f61a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a66680718dcb15deab1f5fd09e97f12f9dfa7ca6b0f3e35ad6c0278e60001ded"
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
