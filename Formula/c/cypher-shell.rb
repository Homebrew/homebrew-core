class CypherShell < Formula
  desc "Command-line shell where you can execute Cypher against Neo4j"
  homepage "https://neo4j.com"
  url "https://dist.neo4j.org/cypher-shell/cypher-shell-5.20.0.zip"
  sha256 "77faa12aed9e6797757b2517da67897c7cc4ee0a849e899994797e4e11968127"
  license "GPL-3.0-only"
  version_scheme 1

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?cypher-shell[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa037fd324bbfa874d7c4dd39713702c801b3db6a893bd895bf8006c1fe2ece4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa037fd324bbfa874d7c4dd39713702c801b3db6a893bd895bf8006c1fe2ece4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa037fd324bbfa874d7c4dd39713702c801b3db6a893bd895bf8006c1fe2ece4"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa037fd324bbfa874d7c4dd39713702c801b3db6a893bd895bf8006c1fe2ece4"
    sha256 cellar: :any_skip_relocation, ventura:        "fa037fd324bbfa874d7c4dd39713702c801b3db6a893bd895bf8006c1fe2ece4"
    sha256 cellar: :any_skip_relocation, monterey:       "fa037fd324bbfa874d7c4dd39713702c801b3db6a893bd895bf8006c1fe2ece4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ea8bac4cef16237f7e94adf672800bd5154cb40fb0e26d5071ca425f9658a79"
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
