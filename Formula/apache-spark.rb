class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=spark/spark-2.1.1/spark-2.1.1-bin-hadoop2.7.tgz"
  version "2.1.1"
  sha256 "372ac4f73221c07696793101007a4f19e31566d1f0d9bd0e5205b6fb5b45bfc2"
  head "https://github.com/apache/spark.git"

  bottle :unneeded

  def install
    # Rename beeline to distinguish it from hive's beeline
    mv "bin/beeline", "bin/spark-beeline"

    rm_f Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/spark-shell <<<'sc.parallelize(1 to 1000).count()'"
  end
end
