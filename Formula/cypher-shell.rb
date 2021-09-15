class CypherShell < Formula
  desc "Command-line shell where you can execute Cypher against Neo4j"
  homepage "https://github.com/neo4j/cypher-shell"
  url "https://github.com/neo4j/cypher-shell/releases/download/4.2.2/cypher-shell.zip"
  sha256 "b57623b045a252e3b46f4bb0c7db4bc5ddb080f248bb866fc27023a7c9118b91"
  license "GPL-3.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d0feb61b9ddf8a28c96f029727b1ce694fe6cfce030e9ba2be96da616c001bb9"
  end

  depends_on "openjdk@11"

  def install
    rm_f Dir["bin/*.bat"]

    # Needs the jar, but cannot go in bin
    libexec.install Dir["cypher-shell{,.jar}"]
    (bin/"cypher-shell").write_env_script libexec/"cypher-shell", Language::Java.overridable_java_home_env("11")
  end

  test do
    # The connection will fail and print the name of the host
    assert_match "doesntexist", shell_output("#{bin}/cypher-shell -a bolt://doesntexist 2>&1", 1)
  end
end
