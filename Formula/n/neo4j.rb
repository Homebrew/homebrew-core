class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "https://neo4j.com/artifact.php?name=neo4j-community-5.18.1-unix.tar.gz"
  sha256 "8cd8bc48ad59f24e9949cf5a6be2fe3e100ac9eb344efea616ea0ab296411089"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?edition=community[^"' >]+release=v?(\d+(?:\.\d+)+)[&"' >]
          |href=.*?release=v?(\d+(?:\.\d+)+)[^"' >]+edition=community/ix)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0866fd9f65ff526b8be42727e2c0429f9612140570014c5361df839525dc9f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0866fd9f65ff526b8be42727e2c0429f9612140570014c5361df839525dc9f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0866fd9f65ff526b8be42727e2c0429f9612140570014c5361df839525dc9f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6fcb7d89a896a6b4115ef1ad71b030ce72afbda0ca40e8629dabe8ed1b5ebcc"
    sha256 cellar: :any_skip_relocation, ventura:        "e6fcb7d89a896a6b4115ef1ad71b030ce72afbda0ca40e8629dabe8ed1b5ebcc"
    sha256 cellar: :any_skip_relocation, monterey:       "e6fcb7d89a896a6b4115ef1ad71b030ce72afbda0ca40e8629dabe8ed1b5ebcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0866fd9f65ff526b8be42727e2c0429f9612140570014c5361df839525dc9f7"
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
