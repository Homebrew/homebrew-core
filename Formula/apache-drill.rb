class ApacheDrill < Formula
  desc "Schema-free SQL query engine for Hadoop and NoSQL"
  homepage "https://drill.apache.org/download/"
  url "https://www-us.apache.org/dist/drill/drill-1.9.0/apache-drill-1.9.0.tar.gz"
  sha256 "ebe668054059b394298a294ab85e44d71facb3ecbf03bf475c5246a6c22fbc89"

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
