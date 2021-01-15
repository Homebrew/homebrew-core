class Liquigraph < Formula
  desc "Migration runner for Neo4j"
  homepage "https://www.liquigraph.org/"
  url "https://github.com/liquigraph/liquigraph/archive/liquigraph-4.0.2.tar.gz"
  sha256 "60d17bb39e7c070a99f4669516cae0c1b0939700127758a9e500e210943f0cca"
  license "Apache-2.0"
  head "https://github.com/liquigraph/liquigraph.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fa0da0d2e5c22f63faed17097c320d4a639c4d3855385f541cf948aa6a5a61b" => :big_sur
    sha256 "bf45c4112732a17a867a17a18cc1ad77d71dbebfdca84f00843bd9526c4d6ed2" => :arm64_big_sur
    sha256 "33d7c1bae094524db782c9b3d3b0f37b4353f772529ab143b456c6271e262059" => :catalina
    sha256 "3a6ed6c8c176e1ffa0e3faef3cd1ed0025663dc23fd2d839372a9766e26fd2b7" => :mojave
    sha256 "d8c4ae157ed9d5ea8aad53d9b07784c21e41a4ac5a7756f0dacb9f526e809405" => :high_sierra
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
    output = shell_output("#{bin}/liquigraph -c #{changelog.realpath} -g #{jdbc} 2>&1", 1)
    assert_match "Exception: #{failing_hostname}", output
  end
end
