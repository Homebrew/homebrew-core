class ApacheSparkAT15 < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org"
  url "https://d3kbcqa49mib13.cloudfront.net/spark-1.5.2-bin-hadoop2.6.tgz"
  version "1.5.2"
  sha256 "409c4b34f196acc5080b893b0579cda000c192fc4cc9336009395b2a559b676e"
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
