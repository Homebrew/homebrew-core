class ApacheDrill < Formula
  desc "Schema-free SQL Query Engine for Hadoop, NoSQL and Cloud Storage"
  homepage "https://drill.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=drill/drill-1.20.0/apache-drill-1.20.0.tar.gz"
  mirror "https://archive.apache.org/dist/drill/drill-1.20.0/apache-drill-1.20.0.tar.gz"
  sha256 "a54e04d0120aa1c34da7693feff9c4497918b25d5e0a8eaf48a9a2ec2073d56e"
  license "Apache-2.0"

  livecheck do
    url "https://drill.apache.org/download/"
    regex(/href=.*?apache-drill[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "28861dd0b660caf226c095344b4d5bbfba86d35fb69d68ab589f968628f23c66"
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
