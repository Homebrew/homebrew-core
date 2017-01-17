class Liquigraph < Formula
  desc "Migration runner for Neo4j"
  homepage "http://www.liquigraph.org"
  url "https://github.com/fbiville/liquigraph/archive/liquigraph-3.0.1.tar.gz"
  sha256 "d2b358187b4a9f250ad1941344f000fc1f3f08bc083c6e12bd3f9cdfa5f557b8"
  head "https://github.com/fbiville/liquigraph.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee6482ffed0bc44bde7872809206eb94a7d2be36bf16458c3d25d699e82637ea" => :sierra
    sha256 "b9977e94e803b3c9b5686e3a77707c3658142b78d7389c653117c88aa4afb560" => :el_capitan
    sha256 "1414e187544b115f58805ecbb4ad4beb84f9620ef9b29c104c5ab2577b1de6e5" => :yosemite
  end

  depends_on "maven" => :build
  depends_on :java => "1.8+"

  def install
    ENV.java_cache
    system "mvn", "-q", "clean", "package", "-DskipTests"
    (buildpath/"binaries").mkpath
    system "tar", "xzf", "liquigraph-cli/target/liquigraph-cli-bin.tar.gz", "-C", "binaries"
    libexec.install "binaries/liquigraph-cli/liquigraph.sh" => "liquigraph"
    libexec.install "binaries/liquigraph-cli/liquigraph-cli.jar"
    bin.install_symlink libexec/"liquigraph"
  end

  test do
    failing_hostname = "verrryyyy_unlikely_host"
    changelog = testpath/"changelog"
    changelog.write <<-EOS.undent
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
