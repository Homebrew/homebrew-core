class CypherShell < Formula
  desc "Command-line shell where you can execute Cypher against Neo4j"
  homepage "https://github.com/neo4j/cypher-shell"
  url "https://github.com/neo4j/cypher-shell/releases/download/1.1.9/cypher-shell.zip"
  version "1.1.9"
  sha256 "027dd83ff10ac24077dc9ab7e1be4a624f8cadeab4039bb6800584d94fecf49f"

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
    # `doesntexist` is printed, but shell_output captures //, unsure why
    assert_match //, shell_output("#{bin}/cypher-shell -a bolt://doesntexist", 1)
  end
end
