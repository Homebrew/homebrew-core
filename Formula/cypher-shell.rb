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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "496af8aff4fef0049d9858080669ca914b4df32b10c9cf402d896fd296c476fd"
    sha256 cellar: :any_skip_relocation, big_sur:       "496af8aff4fef0049d9858080669ca914b4df32b10c9cf402d896fd296c476fd"
    sha256 cellar: :any_skip_relocation, catalina:      "496af8aff4fef0049d9858080669ca914b4df32b10c9cf402d896fd296c476fd"
    sha256 cellar: :any_skip_relocation, mojave:        "496af8aff4fef0049d9858080669ca914b4df32b10c9cf402d896fd296c476fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27991bb1a2895c3391165099d02c6163f00b4fe472f1242e9d2661cfb8f8fca3"
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
