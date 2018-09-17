class ApacheDrill < Formula
  desc "Schema-free SQL Query Engine for Hadoop, NoSQL and Cloud Storage"
  homepage "https://drill.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=drill/drill-1.14.0/apache-drill-1.14.0.tar.gz"
  mirror "https://archive.apache.org/dist/drill/drill-1.14.0/apache-drill-1.14.0.tar.gz"
  sha256 "1145bdbb723119f271d32daf4cdd77cdeebe88ddcb7d04facd585b715bb5723b"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    ENV["DRILL_LOG_DIR"] = ENV["TMP"]
    pipe_output("#{bin}/sqlline -u jdbc:drill:zk=local", "!tables", 0)
  end
end
