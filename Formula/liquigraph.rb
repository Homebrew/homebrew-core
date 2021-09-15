class Liquigraph < Formula
  desc "Migration runner for Neo4j"
  homepage "https://www.liquigraph.org/"
  url "https://github.com/liquigraph/liquigraph/archive/liquigraph-4.0.4.tar.gz"
  sha256 "2ccadb61da07ede6860c32695853456e4844eeb5e64c05f3e61b3c914587a072"
  license "Apache-2.0"
  head "https://github.com/liquigraph/liquigraph.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "be3ede90f882b6636ca5c0374274e659b924bdfee4b67eea10ef8f78596d7b74"
    sha256 cellar: :any_skip_relocation, big_sur:       "888bf68d5125b6c36a89907ae3fab0fbbcef809bf1df7893b02171ba2191edb9"
    sha256 cellar: :any_skip_relocation, catalina:      "7f0ec2c088008c2ba5f96f596dc86dfd4e28e81c93154f14754e33b13ac3978d"
    sha256 cellar: :any_skip_relocation, mojave:        "7f0ec2c088008c2ba5f96f596dc86dfd4e28e81c93154f14754e33b13ac3978d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78fbde2400bc144473a61ecb4f65f92a4ad1eb5244928f5844de51d819225f7c"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    system "mvn", "-B", "-q", "-am", "-pl", "liquigraph-cli", "clean", "package", "-DskipTests"
    (buildpath/"binaries").mkpath
    system "tar", "xzf", "liquigraph-cli/target/liquigraph-cli-bin.tar.gz", "-C", "binaries"
    libexec.install "binaries/liquigraph-cli/liquigraph.sh"
    libexec.install "binaries/liquigraph-cli/liquigraph-cli.jar"
    (bin/"liquigraph").write_env_script libexec/"liquigraph.sh", JAVA_HOME: "${JAVA_HOME:-#{ENV["JAVA_HOME"]}}"
  end

  test do
    failing_hostname = "verrryyyy_unlikely_host"
    changelog = testpath/"changelog"
    changelog.write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <changelog>
          <changeset id="hello-world" author="you">
              <query>CREATE (n:Sentence {text:'Hello monde!'}) RETURN n</query>
          </changeset>
          <changeset id="hello-world-fixed" author="you">
              <query>MATCH (n:Sentence {text:'Hello monde!'}) SET n.text='Hello world!' RETURN n</query>
          </changeset>
      </changelog>
    EOS

    jdbc = "jdbc:neo4j:http://#{failing_hostname}:7474/"
    output = shell_output("#{bin}/liquigraph "\
                          "dry-run -d #{testpath} "\
                          "--changelog #{changelog.realpath} "\
                          "--graph-db-uri #{jdbc} 2>&1", 1)
    assert_match "Exception: #{failing_hostname}", output
  end
end
