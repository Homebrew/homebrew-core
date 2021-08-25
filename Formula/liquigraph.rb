class Liquigraph < Formula
  desc "Migration runner for Neo4j"
  homepage "https://www.liquigraph.org/"
  url "https://github.com/liquigraph/liquigraph/archive/liquigraph-4.0.3.tar.gz"
  sha256 "748ceb4dee52df1edca73570f0ab081ebac2fe93c9c223ea71fa34cbc76553fc"
  license "Apache-2.0"
  head "https://github.com/liquigraph/liquigraph.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c211b70141c8979230564e08eb1ac8f17b84f1597fcb04fac3cd7d88ab1c347b"
    sha256 cellar: :any_skip_relocation, big_sur:       "5bf702e76c38bb142d7b8b4da7323eda9bc7b8603583cc340fad5837d26cdb60"
    sha256 cellar: :any_skip_relocation, catalina:      "684cb3e1e07fc68934c544d448799db40f37bdd999f2f73d4f970e2799a0f986"
    sha256 cellar: :any_skip_relocation, mojave:        "e789e9795a9777d8ecae5552caaccd49647138d6679f67696b5295f46cd9a252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73d617b689a7457e26dee62f1ad2999d319d4ba2f7ecc34d0169419c3e6b8f20"
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
