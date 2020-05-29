class Liquigraph < Formula
  desc "Migration runner for Neo4j"
  homepage "https://www.liquigraph.org/"
  url "https://github.com/liquigraph/liquigraph/archive/liquigraph-4.0.2.tar.gz"
  sha256 "60d17bb39e7c070a99f4669516cae0c1b0939700127758a9e500e210943f0cca"
  head "https://github.com/liquigraph/liquigraph.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5789dd41ea8a05966ce616c79dccb3a5b07b14bec518910d5215c4e7702cac9" => :catalina
    sha256 "4aa2a9b654759ed750a1b677c09dd4ca6ffee08ff4c4d12ecbdb5f652b26399b" => :mojave
    sha256 "8246d256861f742cd5764e15a98b750820092e462d8c681c3ec99b88b0be9999" => :high_sierra
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system "mvn", "-B", "-q", "-am", "-pl", "liquigraph-cli", "clean", "package", "-DskipTests"
    (buildpath/"binaries").mkpath
    system "tar", "xzf", "liquigraph-cli/target/liquigraph-cli-bin.tar.gz", "-C", "binaries"
    libexec.install "binaries/liquigraph-cli/liquigraph.sh"
    libexec.install "binaries/liquigraph-cli/liquigraph-cli.jar"
    (bin/"liquigraph").write_env_script libexec/"liquigraph.sh", :JAVA_HOME => "${JAVA_HOME:-#{ENV["JAVA_HOME"]}}"
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
    assert_match "Exception: #{failing_hostname}", output
  end
end
