class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org/"
  url "https://dlcdn.apache.org/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2.tgz"
  mirror "https://archive.apache.org/dist/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2.tgz"
  version "3.2.1"
  sha256 "224e058cb0c6fb68b39896427a3ccd11ae2246e9bf465b5e29e4fb192d39a59c"
  license "Apache-2.0"
  head "https://github.com/apache/spark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "38bb1c937822a04a206c78dc5d7992d2617c448e8e5adcb650fab83315627a89"
  end

  depends_on "openjdk@11"

  def install
    # Rename beeline to distinguish it from hive's beeline
    mv "bin/beeline", "bin/spark-beeline"

    rm_f Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Formula["openjdk@11"].opt_prefix)
  end

  test do
    assert_match "Long = 1000",
      pipe_output(bin/"spark-shell --conf spark.driver.bindAddress=127.0.0.1",
                  "sc.parallelize(1 to 1000).count()")
  end
end
