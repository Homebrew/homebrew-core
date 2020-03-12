class Liquigraph < Formula
  desc "Migration runner for Neo4j"
  homepage "https://www.liquigraph.org/"
  url "https://github.com/liquigraph/liquigraph/archive/liquigraph-3.1.1.tar.gz"
  sha256 "614f80a553d13549f42c8ac47d0f7ab40db60754223be73fa040bac37f67651a"
  head "https://github.com/liquigraph/liquigraph.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eddfe8687d99efa717ac60299970796c33d943f46c8ab8020f3db1250f662fbf" => :catalina
    sha256 "8771736f1e57e4a404f62ec913d8aacfac1289392f0ce79ff69638a60185d206" => :mojave
    sha256 "abac80d37f57ce38e1c1a69aca6abb36f3807d617d65a90652acb03653c86a42" => :high_sierra
    sha256 "75d8c7d977c82722bc7efd258012baa4d120c5b8f7033834c1a89d9a7d595cde" => :sierra
    sha256 "fbd19556ca00346b211e78afb56bfcee4c6a530234bebc02dce7e4d40fed2b2f" => :el_capitan
  end

  depends_on "maven" => :build
  depends_on :java => "1.8"

  def install
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp
    system "mvn", "-B", "-q", "-am", "-pl", "liquigraph-cli", "clean", "package", "-DskipTests"
    (buildpath/"binaries").mkpath
    system "tar", "xzf", "liquigraph-cli/target/liquigraph-cli-bin.tar.gz", "-C", "binaries"
    libexec.install "binaries/liquigraph-cli/liquigraph.sh"
    libexec.install "binaries/liquigraph-cli/liquigraph-cli.jar"
    (bin/"liquigraph").write_env_script libexec/"liquigraph.sh", Language::Java.java_home_env("1.8")
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
    output = shell_output("#{bin}/liquigraph -c #{changelog.realpath} -g #{jdbc} 2>&1", 1)
    assert_match "UnknownHostException: #{failing_hostname}", output
  end
end
