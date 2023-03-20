class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "https://neo4j.com/artifact.php?name=neo4j-community-5.5.0-unix.tar.gz"
  sha256 "3834cf8393f11d02e96e37b15ceeb4319f56cf1d323076ca242a35750c94bd99"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://neo4j.com/download-center/"
    regex(/href=.*?edition=community[^"' >]+release=v?(\d+(?:\.\d+)+)[&"' >]
          |href=.*?release=v?(\d+(?:\.\d+)+)[^"' >]+edition=community/ix)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a359114c1418043eb8bc6303890cdbe616bde469a4de9a3d667cc3da9267f8d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a359114c1418043eb8bc6303890cdbe616bde469a4de9a3d667cc3da9267f8d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a359114c1418043eb8bc6303890cdbe616bde469a4de9a3d667cc3da9267f8d7"
    sha256 cellar: :any_skip_relocation, ventura:        "260eb47ae00c3f6fdd95fb1b2e9acffaa548149b3f16f73c5de966a6bad4a155"
    sha256 cellar: :any_skip_relocation, monterey:       "260eb47ae00c3f6fdd95fb1b2e9acffaa548149b3f16f73c5de966a6bad4a155"
    sha256 cellar: :any_skip_relocation, big_sur:        "260eb47ae00c3f6fdd95fb1b2e9acffaa548149b3f16f73c5de966a6bad4a155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a359114c1418043eb8bc6303890cdbe616bde469a4de9a3d667cc3da9267f8d7"
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
