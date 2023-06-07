class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "https://neo4j.com/artifact.php?name=neo4j-community-5.8.0-unix.tar.gz"
  sha256 "96d728c337804a255151c23ced29994a890ee4d4015fa3916e34a358f0d1cbd6"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://neo4j.com/download-center/"
    regex(/href=.*?edition=community[^"' >]+release=v?(\d+(?:\.\d+)+)[&"' >]
          |href=.*?release=v?(\d+(?:\.\d+)+)[^"' >]+edition=community/ix)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdaf734d6f5a77464ebf9a7752d2f362640bcf15f657bedeb1664977c7358b55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdaf734d6f5a77464ebf9a7752d2f362640bcf15f657bedeb1664977c7358b55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdaf734d6f5a77464ebf9a7752d2f362640bcf15f657bedeb1664977c7358b55"
    sha256 cellar: :any_skip_relocation, ventura:        "637239bbbcb9aba412e1b0eb40745e2a70743bfb4c17fc37877954d6cda4d8dc"
    sha256 cellar: :any_skip_relocation, monterey:       "637239bbbcb9aba412e1b0eb40745e2a70743bfb4c17fc37877954d6cda4d8dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "637239bbbcb9aba412e1b0eb40745e2a70743bfb4c17fc37877954d6cda4d8dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdaf734d6f5a77464ebf9a7752d2f362640bcf15f657bedeb1664977c7358b55"
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
