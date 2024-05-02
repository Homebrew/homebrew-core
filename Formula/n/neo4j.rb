class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "https://neo4j.com/artifact.php?name=neo4j-community-5.19.0-unix.tar.gz"
  sha256 "30f4eb3156ebdd7905ce2775146c802b9b1104c08c331b1d6ca126aaff5a00d9"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?edition=community[^"' >]+release=v?(\d+(?:\.\d+)+)[&"' >]
          |href=.*?release=v?(\d+(?:\.\d+)+)[^"' >]+edition=community/ix)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd4ae824aa2bdebbabea9ac5e906a5875ceef47d375f75f8e770a86d021a8738"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd4ae824aa2bdebbabea9ac5e906a5875ceef47d375f75f8e770a86d021a8738"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd4ae824aa2bdebbabea9ac5e906a5875ceef47d375f75f8e770a86d021a8738"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec9eb9e367267850264e6642bf145974a919092b537fd141eeda049ede114b49"
    sha256 cellar: :any_skip_relocation, ventura:        "ec9eb9e367267850264e6642bf145974a919092b537fd141eeda049ede114b49"
    sha256 cellar: :any_skip_relocation, monterey:       "ec9eb9e367267850264e6642bf145974a919092b537fd141eeda049ede114b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd4ae824aa2bdebbabea9ac5e906a5875ceef47d375f75f8e770a86d021a8738"
  end

  depends_on "openjdk"

  def install
    env = {
      JAVA_HOME:  Formula["openjdk"].opt_prefix,
      NEO4J_HOME: libexec,
    }
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Install jars in libexec to avoid conflicts
    libexec.install Dir["*"]

    # Symlink binaries
    bin.install Dir["#{libexec}/bin/neo4j{,-shell,-import,-shared.sh,-admin}", "#{libexec}/bin/cypher-shell"]
    bin.env_script_all_files(libexec/"bin", env)

    # Adjust UDC props
    # Suppress the empty, focus-stealing java gui.
    (libexec/"conf/neo4j.conf").append_lines <<~EOS
      server.jvm.additional=-Djava.awt.headless=true-Dunsupported.dbms.udc.source=homebrew
      server.directories.data=#{var}/neo4j/data
      server.directories.logs=#{var}/log/neo4j
    EOS
  end

  def post_install
    (var/"log/neo4j").mkpath
    (var/"neo4j").mkpath
  end

  service do
    run [opt_bin/"neo4j", "console"]
    keep_alive false
    working_dir var
    log_path var/"log/neo4j.log"
    error_log_path var/"log/neo4j.log"
  end

  test do
    ENV["NEO4J_HOME"] = libexec
    ENV["NEO4J_LOG"] = testpath/"libexec/data/log/neo4j.log"
    ENV["NEO4J_PIDFILE"] = testpath/"libexec/data/neo4j-service.pid"
    mkpath testpath/"libexec/data/log"
    assert_match(/Neo4j .*is not running/i, shell_output("#{bin}/neo4j status 2>&1", 3))
  end
end
