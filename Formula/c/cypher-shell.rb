class CypherShell < Formula
  desc "Command-line shell where you can execute Cypher against Neo4j"
  homepage "https://neo4j.com"
  url "https://dist.neo4j.org/cypher-shell/cypher-shell-5.22.0.zip"
  sha256 "9b9e6a187aef05aeda744d655b8139d50fd1d7a9f5dea2a14c792e13c2e19113"
  license "GPL-3.0-only"
  version_scheme 1

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?cypher-shell[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ea790f92a9455673a1539fa2807f1e42762f7a4422403c2364da1c09180a39c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ea790f92a9455673a1539fa2807f1e42762f7a4422403c2364da1c09180a39c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ea790f92a9455673a1539fa2807f1e42762f7a4422403c2364da1c09180a39c"
    sha256 cellar: :any_skip_relocation, sonoma:         "0db26ef4a8cd51d6cb6b2d6ce97285b382ad50d3979fd48783bb9e72735ba0be"
    sha256 cellar: :any_skip_relocation, ventura:        "0db26ef4a8cd51d6cb6b2d6ce97285b382ad50d3979fd48783bb9e72735ba0be"
    sha256 cellar: :any_skip_relocation, monterey:       "7ea790f92a9455673a1539fa2807f1e42762f7a4422403c2364da1c09180a39c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "858a49f9955d7f10ad6e0726782eea37d114928bf70f2ee0299b5e491d45d2ca"
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
