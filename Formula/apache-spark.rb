class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz"
  version "2.4.0"
  sha256 "c93c096c8d64062345b26b34c85127a6848cff95a4bb829333a06b83222a5cfa"
  head "https://github.com/apache/spark.git"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    # Rename beeline to distinguish it from hive's beeline
    mv "bin/beeline", "bin/spark-beeline"

    rm_f Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    assert_match "Long = 1000", pipe_output(bin/"spark-shell --conf spark.driver.bindAddress=127.0.0.1", "sc.parallelize(1 to 1000).count()")
  end
end
