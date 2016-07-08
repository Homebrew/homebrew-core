class ApacheDrill < Formula
  desc "Schema-free SQL query engine for Hadoop and NoSQL"
  homepage "https://drill.apache.org/download/"
  url "https://www.apache.org/dyn/closer.cgi?path=drill/drill-1.7.0/apache-drill-1.7.0.tar.gz"
  mirror "https://archive.apache.org/dist/drill/drill-1.7.0/apache-drill-1.7.0.tar.gz"
  sha256 "b2216bd3c5a6047dc45134c22c0a0e9bac48daa9a4c5dd09b6eeed3cb83616d0"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    ENV.java_cache

    pipe_output("#{bin}/sqlline -u jdbc:drill:zk=local", "!tables", 0)
  end
end
