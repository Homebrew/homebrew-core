class Octosql < Formula
  desc "SQL query tool to analyze data from different file formats and databases"
  homepage "https://github.com/cube2222/octosql/"
  url "https://github.com/cube2222/octosql/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "60a111c38be45c7c987605e7c4c16ba1821de24a2a046aba4234f3343061f3e6"
  license "MPL-2.0"
  head "https://github.com/cube2222/octosql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad91a6236138adcdaa8ccec25c993c5bef6cd4839d73dd38efa502cce8ec3f2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6e11fb386d808cfa06324f509109ba1700d095193d29ee087dbae1338657b29"
    sha256 cellar: :any_skip_relocation, monterey:       "f1d7d4beface0b1b4f367c8dbeaefb33634010dd55857744c91d26b8ef32980b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ff1c3606abb2ff75bc94b509e867dd8f11a57e142630897d83cc0ba306140ac"
    sha256 cellar: :any_skip_relocation, catalina:       "b6bdca4e6dc87885bad926912c3e5c30bcb8c84fbbf59a7411f67df93ae4be6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "363b7dae98f8dd731a74c57759ba26e504b92c73824e9ac48a94ba3edd4d7b29"
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
