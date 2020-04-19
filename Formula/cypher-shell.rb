class CypherShell < Formula
  desc "Command-line shell where you can execute Cypher against Neo4j"
  homepage "https://github.com/neo4j/cypher-shell"
  url "https://github.com/neo4j/cypher-shell/releases/download/4.0.3/cypher-shell.zip"
  sha256 "48598744a2585b9c2b57fbc47af3cbe56b0de016af6ff81977b8ec4ddb587228"
  version_scheme 1

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    rm_f Dir["bin/*.bat"]

    # Needs the jar, but cannot go in bin
    share.install ["cypher-shell.jar"]

    # Copy the bin
    bin.install ["cypher-shell"]
    bin.env_script_all_files(share, :NEO4J_HOME => ENV["NEO4J_HOME"])
  end

  test do
    # The connection will fail and print the name of the host
    assert_match /doesntexist/, shell_output("#{bin}/cypher-shell -a bolt://doesntexist 2>&1", 1)
  end
end
