class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "https://neo4j.com/artifact.php?name=neo4j-community-5.22.0-unix.tar.gz"
  sha256 "80ae623641a3b353e3b2bca5e49cb6f0dbb79d89d512850c751c356a1378c444"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?edition=community[^"' >]+release=v?(\d+(?:\.\d+)+)[&"' >]
          |href=.*?release=v?(\d+(?:\.\d+)+)[^"' >]+edition=community/ix)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d7e5338256753dc9dc11320f86c27a480926937c6349d6b66a5af46e892d737"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d7e5338256753dc9dc11320f86c27a480926937c6349d6b66a5af46e892d737"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d7e5338256753dc9dc11320f86c27a480926937c6349d6b66a5af46e892d737"
    sha256 cellar: :any_skip_relocation, sonoma:         "51b0257d78063414c390060603e50a34e1ff0f285813300bf97f26e37ec34b69"
    sha256 cellar: :any_skip_relocation, ventura:        "f0c4925f5b7e77cf1dbedaa6738563aebdab3d641888291fb8ef9025f94764b1"
    sha256 cellar: :any_skip_relocation, monterey:       "51b0257d78063414c390060603e50a34e1ff0f285813300bf97f26e37ec34b69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ce44f81ddb230cb5625c31893b464a546e8105a6043990c369cc70c83b4ed80"
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

    # Symlink binaries
    bin.install Dir["#{libexec}/bin/neo4j{,-shell,-import,-shared.sh,-admin}"]
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
