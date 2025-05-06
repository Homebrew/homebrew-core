class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "https://neo4j.com/artifact.php?name=neo4j-community-2025.04.0-unix.tar.gz"
  sha256 "118cb439904d1aaad67f2421be518d2acc2b754f621acc209ee3362e5b67ba65"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?edition=community[^"' >]+release=v?(\d+(?:\.\d+)+)[&"' >]
          |href=.*?release=v?(\d+(?:\.\d+)+)[^"' >]+edition=community/ix)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "68bdaaa4ea98456b892250aa3e3a17a004dcda68e44cb1bc95c5d780c3c1c9dd"
  end

  depends_on "cypher-shell"
  depends_on "openjdk@21"

  def install
    env = {
      JAVA_HOME:  Formula["openjdk@21"].opt_prefix,
      NEO4J_HOME: libexec,
    }
    # Remove windows files
    rm(Dir["bin/*.bat"])

    # Install jars in libexec to avoid conflicts
    libexec.install Dir["*"]

    bash_completion.install (libexec/"bin/completion").children
    # Ensure uniform bottles by replacing comments that reference `/usr/local`.
    inreplace bash_completion.children, "/usr/local", HOMEBREW_PREFIX
    rm_r libexec/"bin/completion"

    # Symlink binaries
    bin.install libexec.glob("bin/neo4j*")
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
