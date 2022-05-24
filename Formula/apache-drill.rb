class ApacheDrill < Formula
  desc "Schema-free SQL Query Engine for Hadoop, NoSQL and Cloud Storage"
  homepage "https://drill.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=drill/drill-1.20.1/apache-drill-1.20.1.tar.gz"
  mirror "https://archive.apache.org/dist/drill/drill-1.20.1/apache-drill-1.20.1.tar.gz"
  sha256 "527a196d35a2ae3eadf5a364048c760cb2452cf924edccab5ccafb55815f2632"
  license "Apache-2.0"

  livecheck do
    url "https://drill.apache.org/download/"
    regex(/href=.*?apache-drill[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "09a6a641caaf79a3523186a9ed503dad64a4d7acd55ac3e00933a0833cb2a935"
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
