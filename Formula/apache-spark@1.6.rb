class ApacheSparkAT16 < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org"
  url "http://d3kbcqa49mib13.cloudfront.net/spark-1.6.3-bin-hadoop2.6.tgz"
  version "1.6.3"
  sha256 "389e79458ad1d8ad8044643d97304d09bf3ca31f804c386e560033c48123cd69"
  revision 1

  bottle :unneeded

  keg_only :versioned_formula

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
