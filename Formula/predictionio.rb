class Predictionio < Formula
  desc "Source machine learning server"
  homepage "http://predictionio.incubator.apache.org/"
  url "http://download.prediction.io/PredictionIO-0.9.6.tar.gz"
  sha256 "d64ee99f50094b36accac4deae1008372c15f2cbc6112f6a7d8094842cf57e86"

  bottle :unneeded

  depends_on "elasticsearch"
  depends_on "hadoop"
  depends_on "hbase"
  depends_on "apache-spark"
  depends_on :java => "1.7+"

  def install
    rm_f Dir["bin/*.bat"]

    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/pio"

    inreplace libexec/"conf/pio-env.sh" do |s|
      s.gsub! /#\s*ES_CONF_DIR=.+$/, "ES_CONF_DIR=#{Formula["elasticsearch"].opt_prefix}/config"
      s.gsub! /SPARK_HOME=.+$/, "SPARK_HOME=#{Formula["apache-spark"].opt_prefix}"
    end
  end
end
