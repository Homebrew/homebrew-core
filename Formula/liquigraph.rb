class Liquigraph < Formula
  desc "Migration runner for Neo4j"
  homepage "http://www.liquigraph.org"
  url "https://github.com/liquigraph/liquigraph/archive/liquigraph-3.0.2.tar.gz"
  sha256 "99a4eaf26834de5be45665aa7fda4f666e2f75c48cac47da33e173111b5be352"
  head "https://github.com/liquigraph/liquigraph.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2189a2a685df08160de2394796bfd9a3fe1aabb9315e92afa3d5b7d30b7e100c" => :high_sierra
    sha256 "27c0b44defad178d85022d6ca10686e3f96784ca7e54465678891d177223b61d" => :sierra
    sha256 "567394a0b344152634380c55693ec2e481db6f6a4e3fc592cc55f960ac8c5cb2" => :el_capitan
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
