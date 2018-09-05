class ApacheDrill < Formula
  desc "Schema-free SQL Query Engine for Hadoop, NoSQL and Cloud Storage"
  homepage "https://drill.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=drill/drill-1.13.0/apache-drill-1.13.0.tar.gz"
  mirror "https://archive.apache.org/dist/drill/drill-1.13.0/apache-drill-1.13.0.tar.gz"
  sha256 "8da6d56f75ae01e0bee6176095d32760e7183dd0200f10ee68b8cd3f882def6a"

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
