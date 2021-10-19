class CypherShell < Formula
  desc "Command-line shell where you can execute Cypher against Neo4j"
  homepage "https://neo4j.com"
  url "https://dist.neo4j.org/cypher-shell/cypher-shell-4.3.0.zip"
  sha256 "bd61dd4cffcfc8935bc3cf06b4d3591eda46d56d43dd0b88e494ccd518d105d1"
  license "GPL-3.0-only"
  version_scheme 1

  livecheck do
    url "https://neo4j.com/download-center/"
    regex(/href=.*?cypher-shell[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

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
