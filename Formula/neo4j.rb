class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "http://neo4j.com"
  url "http://dist.neo4j.org/neo4j-community-2.3.3-unix.tar.gz"
  version "2.3.3"
  sha256 "01559c55055516a42ee2dd100137b6b55d63f02959a3c6c6db7a152e045828d9"

  devel do
    url "http://dist.neo4j.org/neo4j-community-3.0.0-M05-unix.tar.gz"
    sha256 "2b7878f424859de6951e86f9abb71701d8d45ab22e1157410504fe6a6bb17a95"
    version "3.0.0-M05"
  end

  bottle :unneeded

  depends_on :java

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Install jars in libexec to avoid conflicts
    libexec.install Dir["*"]

    # Symlink binaries
    bin.install_symlink Dir["#{libexec}/bin/neo4j{,-shell,-import}"]

    # Adjust UDC props
    # Suppress the empty, focus-stealing java gui.
    (libexec/"conf/neo4j-wrapper.conf").append_lines <<-EOS.undent
      wrapper.java.additional=-Djava.awt.headless=true
      wrapper.java.additional.4=-Dneo4j.ext.udc.source=homebrew
    EOS
  end

  test do
    ENV["NEO4J_LOG"] = testpath/"libexec/data/log/neo4j.log"
    ENV["NEO4J_PIDFILE"] = testpath/"libexec/data/neo4j-service.pid"
    system "#{HOMEBREW_PREFIX}/bin/neo4j", "start"
    system "#{HOMEBREW_PREFIX}/bin/neo4j", "stop"
  end
end
