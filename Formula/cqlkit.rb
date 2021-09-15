class Cqlkit < Formula
  desc "CLI tool to export Cassandra query as CSV and JSON format"
  homepage "https://github.com/tenmax/cqlkit"
  url "https://github.com/tenmax/cqlkit/releases/download/v0.3.3/cqlkit-0.3.3.zip"
  sha256 "0574b4b6fe893078e993a80f95a183b89955129ab8929f5032b7faacf611952c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "355be366040067ccf68d6bdaa4f212c8da622bacefad1ba9a61d33e680141ac5"
  end

  depends_on "openjdk"

  def install
    libexec.install %w[bin lib]
    rm_f Dir["#{libexec}/bin/*.bat"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    output = shell_output("#{bin}/cql2cql -c localhost -q 'select peer from system.peers' 2>&1", 1)
    assert_match(/.*Error: All host\(s\) tried for query failed.*/, output)
    output = shell_output("#{bin}/cql2csv -c localhost -q 'select peer from system.peers' 2>&1", 1)
    assert_match(/.*Error: All host\(s\) tried for query failed.*/, output)
    output = shell_output("#{bin}/cql2json -c localhost -q 'select peer from system.peers' 2>&1", 1)
    assert_match(/.*Error: All host\(s\) tried for query failed.*/, output)
    output = shell_output("#{bin}/cqlkit -c localhost -q 'select peer from system.peers' 2>&1", 1)
    assert_match(/.*Error: All host\(s\) tried for query failed.*/, output)
  end
end
