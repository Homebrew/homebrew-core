class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "https://neo4j.com/artifact.php?name=neo4j-community-5.20.0-unix.tar.gz"
  sha256 "203215748402702871e511c6dfff3c62f72587c4e80df703bf854085c436d066"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?edition=community[^"' >]+release=v?(\d+(?:\.\d+)+)[&"' >]
          |href=.*?release=v?(\d+(?:\.\d+)+)[^"' >]+edition=community/ix)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "031d542cfab50907c5d96b2f5de91982dff6c94fb7a70e633ad2dc33b017f689"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1888fd646917efc98fcd31310094c04980635b9f6727ba16460288fd2a324829"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07d740c4e2d2e64af354da6b0ff11ae9bb26af29493189a217f3d2599be33976"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2fd01a59fa5e27428c329a1f52b7d29130328d02ae0acc967aa893e00915bf9"
    sha256 cellar: :any_skip_relocation, ventura:        "9f9aa38a574abc2d9fad53ba96ad391cc428e7f916534387672ac1145c3843de"
    sha256 cellar: :any_skip_relocation, monterey:       "d78200956821b6fae8af4e210a12c3d855da58075c648a36656d21cad0f88736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cb055e6920dab0cec271afa6e973d5def25c5fbbde0f445373e78e15b5a260a"
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
