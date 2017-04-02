class ApacheDrill < Formula
  desc "Schema-free SQL Query Engine for Hadoop, NoSQL and Cloud Storage"
  homepage "https://drill.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=drill/drill-1.10.0/apache-drill-1.10.0.tar.gz"
  mirror "https://archive.apache.org/dist/drill/drill-1.10.0/apache-drill-1.10.0.tar.gz"
  sha256 "92286f941cd0264eba57789d75759e7b598bf7463952dba40e81696452ea5d8a"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    ENV.java_cache

    ENV["DRILL_LOG_DIR"] = ENV["TMP"]
    pipe_output("#{bin}/sqlline -u jdbc:drill:zk=local", "!tables", 0)
  end
end
