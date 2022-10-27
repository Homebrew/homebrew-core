class CypherShell < Formula
  desc "Command-line shell where you can execute Cypher against Neo4j"
  homepage "https://neo4j.com"
  url "https://dist.neo4j.org/cypher-shell/cypher-shell-5.1.0.zip"
  sha256 "2df90ca66d1c60fcc7ad237239d3f49f5f944252082ea4549a5eb44b6083b3a5"
  license "GPL-3.0-only"
  version_scheme 1

  livecheck do
    url "https://neo4j.com/download-center/"
    regex(/href=.*?cypher-shell[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ef1165ed2c412526ff0618fdec0f431f7871811be756ff84f7f441b3bfb5ad6"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"cypher-shell").write_env_script libexec/"bin/cypher-shell", Language::Java.overridable_java_home_env
  end

  test do
    # The connection will fail and print the name of the host
    assert_match "doesntexist", shell_output("#{bin}/cypher-shell -a bolt://doesntexist 2>&1", 1)
  end
end
