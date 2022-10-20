class ApacheDrill < Formula
  desc "Schema-free SQL Query Engine for Hadoop, NoSQL and Cloud Storage"
  homepage "https://drill.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=drill/1.20.2/apache-drill-1.20.2.tar.gz"
  mirror "https://dlcdn.apache.org/drill/1.20.2/apache-drill-1.20.2.tar.gz"
  sha256 "2d4c7d85211b214b057d2bd4c081fdcf3c3898e866f7690e3f4a6ab25d1a4bed"
  license "Apache-2.0"

  livecheck do
    url "https://drill.apache.org/download/"
    regex(/href=.*?apache-drill[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e07eb503674dae295482a82130fc3dd840743b5e424c713fbccb03645c886981"
  end

  depends_on "openjdk@11"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("11"))
    rm_f Dir["#{bin}/*.txt"]
  end

  test do
    ENV["DRILL_LOG_DIR"] = ENV["TMP"]
    pipe_output("#{bin}/sqlline -u jdbc:drill:zk=local", "!tables", 0)
  end
end
