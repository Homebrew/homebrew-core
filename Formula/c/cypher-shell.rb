class CypherShell < Formula
  desc "Command-line shell where you can execute Cypher against Neo4j"
  homepage "https://neo4j.com"
  url "https://dist.neo4j.org/cypher-shell/cypher-shell-5.24.1.zip"
  sha256 "f4107315c72a0c566964565553d7edfacda2992351ff9d005157933f7567422a"
  license "GPL-3.0-only"
  version_scheme 1

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?cypher-shell[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ee2a13db31389e26f076de68d535a089fe9d822b07853125a38a6acc9cc47831"
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
