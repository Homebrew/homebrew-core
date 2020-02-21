class ApacheDrill < Formula
  desc "Schema-free SQL Query Engine for Hadoop, NoSQL and Cloud Storage"
  homepage "https://drill.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=drill/drill-1.16.0/apache-drill-1.16.0.tar.gz"
  mirror "https://archive.apache.org/dist/drill/drill-1.16.0/apache-drill-1.16.0.tar.gz"
  sha256 "fd195d2b38f393459b37d8f13ac1f36cdbe38495eabb08252da38e3544e87839"

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
