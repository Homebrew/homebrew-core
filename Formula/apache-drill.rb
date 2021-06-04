class ApacheDrill < Formula
  desc "Schema-free SQL Query Engine for Hadoop, NoSQL and Cloud Storage"
  homepage "https://drill.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=drill/drill-1.18.0/apache-drill-1.18.0.tar.gz"
  mirror "https://archive.apache.org/dist/drill/drill-1.18.0/apache-drill-1.18.0.tar.gz"
  sha256 "e58fc1bed0fe3a0ef101a0705404e887af3f79beaccde8b225e884c06d336597"
  license "Apache-2.0"

  livecheck do
    url "https://drill.apache.org/download/"
    regex(/href=.*?apache-drill[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle :unneeded

  depends_on "openjdk@8"

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
