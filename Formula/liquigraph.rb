class Liquigraph < Formula
  desc "Migration runner for Neo4j"
  homepage "https://www.liquigraph.org/"
  url "https://github.com/liquibase/liquigraph/archive/liquigraph-4.0.6.tar.gz"
  sha256 "c51283a75346f8d4c7bb44c6a39461eb3918ac5b150ec3ae157f9b12c4150566"
  license "Apache-2.0"
  head "https://github.com/liquibase/liquigraph.git", branch: "4.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd9bfe32b4de80a9fb329b0e31718366cb3d084b7916b9989c27cf0b9dec8e51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2657ed5db8ad3d0e90a2fe423ab3cd6dc80a5e2ab31491a1e28321ea18ecba8e"
    sha256 cellar: :any_skip_relocation, ventura:       "f27dd77626c267a36aac57e8ffb05fef7dfe9a343c15a4bc6c21313463af3c76"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9b148e1dc0d02e6cc2ead6239afa1d9722b66a6735b3e04a09fee53c449c473"
    sha256 cellar: :any_skip_relocation, catalina:      "9edfa9189feac35f00e7ff23b05b65591c66d8ca39af1ce39729223152c3fe41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a431c7b9691e73bccbe98fdb79dfa02ceaefdd2cd37a41ecc323edf93301e7b2"
  end

  # deprecate in favor of liquibase
  deprecate! date: "2022-05-08", because: :repo_archived

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
    output = shell_output("#{bin}/liquigraph " \
                          "dry-run -d #{testpath} " \
                          "--changelog #{changelog.realpath} " \
                          "--graph-db-uri #{jdbc} 2>&1", 1)
    assert_match "Exception: #{failing_hostname}", output
  end
end
