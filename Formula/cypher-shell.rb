class CypherShell < Formula
  desc "Command-line shell where you can execute Cypher against Neo4j"
  homepage "https://neo4j.com"
  url "https://dist.neo4j.org/cypher-shell/cypher-shell-4.4.4.zip"
  sha256 "e4624963717118d41d9cd39b0a6df6f7f0a49b89d6dea40b809777120228adfa"
  license "GPL-3.0-only"
  version_scheme 1

  livecheck do
    url "https://neo4j.com/download-center/"
    regex(/href=.*?cypher-shell[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "155a26fa2388eaed7f0de17f297065122961aa9a51f9cca99b2ad4e68842c67b"
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
