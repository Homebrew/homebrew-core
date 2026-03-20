class CypherShell < Formula
  desc "Command-line shell where you can execute Cypher against Neo4j"
  homepage "https://neo4j.com"
  url "https://dist.neo4j.org/cypher-shell/cypher-shell-2026.02.2.zip"
  sha256 "3ff22a0c6cf1f69abcda5308468c3c2781d39c37611d6f05f54f6cb61c82f68e"
  license "GPL-3.0-only"
  version_scheme 1

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?cypher-shell[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fbbf4cae1201ed475effd4a581ebbf651ac7b2d356a9b579d30975bc9b11ddde"
  end

  depends_on "openjdk@21"

  def install
    libexec.install Dir["*"]
    (bin/"cypher-shell").write_env_script libexec/"bin/cypher-shell", Language::Java.overridable_java_home_env("21")
  end

  test do
    refute_match "unsupported version of the Java runtime", shell_output("#{bin}/cypher-shell -h 2>&1", 1)
    # The connection will fail and print the name of the host
    assert_match "doesntexist", shell_output("#{bin}/cypher-shell -a bolt://doesntexist 2>&1", 1)
  end
end
