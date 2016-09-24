class Liquigraph < Formula
  desc "Migration runner for Neo4j"
  homepage "http://www.liquigraph.org"
  url "https://github.com/fbiville/liquigraph/archive/liquigraph-3.0.0.tar.gz"
  sha256 "4864c323a626c15df9fed49d05ede3e947e0b78fe864ff81dcc8703b875662b1"
  head "https://github.com/fbiville/liquigraph.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "68fe2a70de1b7df7c4207ee2e83e0f80f94e40735152272752cf3b78bdcbc5e2" => :el_capitan
    sha256 "c6bc6dd5f9769bbf176c44e1f72e08b43f14f2ba3ae21442bbd1b465378aff7d" => :yosemite
    sha256 "d61206398e4b4a24b88b9ca44957f99db227d8a6a259b74a111c6f4d6fc38b8e" => :mavericks
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
