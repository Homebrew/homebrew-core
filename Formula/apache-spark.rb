class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=spark/spark-2.1.0/spark-2.1.0-bin-hadoop2.7.tgz"
  version "2.1.0"
  sha256 "0834c775f38473f67cb122e0ec21074f800ced50c1ff1b9e37e222a0069dc5c7"
  revision 1
  head "https://github.com/apache/spark.git"

  bottle :unneeded

  patch do
    url "https://github.com/apache/spark/pull/16429.patch"
    sha256 "70edb1a3b8560c28b98fa170c4c0ea57aca67eaf3ec62ee80380576768bf24d0"
  end

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
