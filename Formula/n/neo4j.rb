class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "https://neo4j.com/artifact.php?name=neo4j-community-5.18.0-unix.tar.gz"
  sha256 "5cfa57e9a94b6fcd68e48057d7a7871e424c8bc57f47fd985d6382c441ca754d"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?edition=community[^"' >]+release=v?(\d+(?:\.\d+)+)[&"' >]
          |href=.*?release=v?(\d+(?:\.\d+)+)[^"' >]+edition=community/ix)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b48d6f6676600d4f90833a31e4a7e428e99a7bb1c8101d7f0eff9f9da5008c12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b48d6f6676600d4f90833a31e4a7e428e99a7bb1c8101d7f0eff9f9da5008c12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b48d6f6676600d4f90833a31e4a7e428e99a7bb1c8101d7f0eff9f9da5008c12"
    sha256 cellar: :any_skip_relocation, sonoma:         "cce13f4a6991ec92e401b985ab63e802ad3c5e855494ce733a188e97eadbbe4c"
    sha256 cellar: :any_skip_relocation, ventura:        "cce13f4a6991ec92e401b985ab63e802ad3c5e855494ce733a188e97eadbbe4c"
    sha256 cellar: :any_skip_relocation, monterey:       "cce13f4a6991ec92e401b985ab63e802ad3c5e855494ce733a188e97eadbbe4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b48d6f6676600d4f90833a31e4a7e428e99a7bb1c8101d7f0eff9f9da5008c12"
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
