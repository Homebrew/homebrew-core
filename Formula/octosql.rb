class Octosql < Formula
  desc "SQL query tool to analyze data from different file formats and databases"
  homepage "https://github.com/cube2222/octosql/"
  url "https://github.com/cube2222/octosql/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "60a111c38be45c7c987605e7c4c16ba1821de24a2a046aba4234f3343061f3e6"
  license "MPL-2.0"
  head "https://github.com/cube2222/octosql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34dff059c18e886156382cc68e84de8b6cf3e35feda227b30b48967dd34a6896"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca37e6e48a6b8874866cfb64744575f00d6d2d3a6007fab7f9c4cdfc8c9c0331"
    sha256 cellar: :any_skip_relocation, monterey:       "8cd1a3a6a35393d921a526c53a37d733b53641b173c113e0fe24bed816df6b49"
    sha256 cellar: :any_skip_relocation, big_sur:        "650c03abbe4ca4daeae1854711fcb32dc50d13874781e85d0d6f21e90f987382"
    sha256 cellar: :any_skip_relocation, catalina:       "32b1b356e3afcef82a484668b9bb70e3635c4ebdd840544f4edb3bfbd314644c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f9cea99071584f27a5206b8395951cec74e035f962721a66db14c5c97465b9f"
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
