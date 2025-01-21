class ApacheDrill < Formula
  desc "Schema-free SQL Query Engine for Hadoop, NoSQL and Cloud Storage"
  homepage "https://drill.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=drill/1.21.2/apache-drill-1.21.2.tar.gz"
  mirror "https://dlcdn.apache.org/drill/1.21.2/apache-drill-1.21.2.tar.gz"
  sha256 "77e2e7438f1b4605409828eaa86690f1e84b038465778a04585bd8fb21d68e3b"
  license "Apache-2.0"

  livecheck do
    url "https://drill.apache.org/download/"
    regex(/href=.*?apache-drill[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9645d66cd920bf65041bac079231869addd9e6217450bb6694af1067e06dc723"
  end

  depends_on "openjdk@11"

  def install
    rm(Dir["bin/*.bat"])
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("11"))
    rm(Dir["#{bin}/*.txt"])
  end

  test do
    ENV["DRILL_LOG_DIR"] = ENV["TMP"]
    pipe_output("#{bin}/sqlline -u jdbc:drill:zk=local", "!tables", 0)
  end
end
