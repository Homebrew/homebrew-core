class Octosql < Formula
  desc "SQL query tool to analyze data from different file formats and databases"
  homepage "https://github.com/cube2222/octosql/"
  url "https://github.com/cube2222/octosql/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "408e0f5d7bfd9f8e7903ce1d6c55214e0c22c4d5c2b84195139afc0c12ac9fa7"
  license "MPL-2.0"
  head "https://github.com/cube2222/octosql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52b4c13b613637d66e7d0443efe0040ac90442d1d684f8e8884fe6ceb4f56c33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6156175e4da8c8aadc75a8d0e0d58eae0c168f9980cdf885a0b2bfbd34c907c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa962c981b327d7bebf33b92131ef1862dac2276a3611e74ec16f36af0b4d358"
    sha256 cellar: :any_skip_relocation, ventura:        "877a3cd39081445e58f956c706e46f9cfb0b273f19647b080587b6f4ba32bac5"
    sha256 cellar: :any_skip_relocation, monterey:       "19811afa112521f3bb76d0af5906399e8305349b134cc6af2dacb89aa7f2a7e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "184450555f85574e9978f781ef488013a77a4a30d12360fa1d40e4859492e78e"
    sha256 cellar: :any_skip_relocation, catalina:       "d8da82a4f2204f4a3ab90ab1b35b7e14bdf1d72c230de1cc0e27b2c7cf8b131b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c666326c70572fbc67ff37e07483baec324ef7c2afdbf6b274f477c2a4874bb5"
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
