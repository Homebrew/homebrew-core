class ApacheDrill < Formula
  desc "Schema-free SQL Query Engine for Hadoop, NoSQL and Cloud Storage"
  homepage "https://drill.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=drill/1.21.0/apache-drill-1.21.0.tar.gz"
  mirror "https://dlcdn.apache.org/drill/1.21.0/apache-drill-1.21.0.tar.gz"
  sha256 "d4581a4ed6a2a3371c698114f68815361a62f6ce9fdf91eb0a22fce7b7364152"
  license "Apache-2.0"

  livecheck do
    url "https://drill.apache.org/download/"
    regex(/href=.*?apache-drill[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3f21a039e3ce31ace48ebfe839f96996c0a2994e8e246f66154ba0b758d28c5c"
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
