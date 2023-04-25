class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "https://neo4j.com/artifact.php?name=neo4j-community-5.7.0-unix.tar.gz"
  sha256 "e13e94d8c8730f9525f30f98821ade79b349af1697d7ac94a8c3cc8b0273b734"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://neo4j.com/download-center/"
    regex(/href=.*?edition=community[^"' >]+release=v?(\d+(?:\.\d+)+)[&"' >]
          |href=.*?release=v?(\d+(?:\.\d+)+)[^"' >]+edition=community/ix)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b49d8467b1040cb979dc3a75b8329f41fe28533d56de86557e7cf630b60d1b82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b49d8467b1040cb979dc3a75b8329f41fe28533d56de86557e7cf630b60d1b82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b49d8467b1040cb979dc3a75b8329f41fe28533d56de86557e7cf630b60d1b82"
    sha256 cellar: :any_skip_relocation, ventura:        "8cd3656d593943a199921342e55837866dfc7a84e63efaa505264c37779b97c5"
    sha256 cellar: :any_skip_relocation, monterey:       "8cd3656d593943a199921342e55837866dfc7a84e63efaa505264c37779b97c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cd3656d593943a199921342e55837866dfc7a84e63efaa505264c37779b97c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b49d8467b1040cb979dc3a75b8329f41fe28533d56de86557e7cf630b60d1b82"
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
      wrapper.java.additional=-Djava.awt.headless=true
      wrapper.java.additional.4=-Dneo4j.ext.udc.source=homebrew
      dbms.directories.data=#{var}/neo4j/data
      dbms.directories.logs=#{var}/log/neo4j
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
