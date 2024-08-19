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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd822ed8d1754add90f7bff790c2ddbefbb6c74ed1041aa99ef77a0154e52c07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd822ed8d1754add90f7bff790c2ddbefbb6c74ed1041aa99ef77a0154e52c07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd822ed8d1754add90f7bff790c2ddbefbb6c74ed1041aa99ef77a0154e52c07"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd822ed8d1754add90f7bff790c2ddbefbb6c74ed1041aa99ef77a0154e52c07"
    sha256 cellar: :any_skip_relocation, ventura:        "bd822ed8d1754add90f7bff790c2ddbefbb6c74ed1041aa99ef77a0154e52c07"
    sha256 cellar: :any_skip_relocation, monterey:       "bd822ed8d1754add90f7bff790c2ddbefbb6c74ed1041aa99ef77a0154e52c07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "895478c53621805c15c2c1a8d984e2c2630b8bf2fcd9e561926bdd30a6281ccf"
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
