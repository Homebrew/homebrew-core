class Predictionio < Formula
  desc "Source machine learning server"
  homepage "https://predictionio.incubator.apache.org/"
  url "https://github.com/apache/incubator-predictionio/releases/download/v0.9.6/PredictionIO-0.9.6.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/predictionio-0.9.6.tar.gz"
  sha256 "d64ee99f50094b36accac4deae1008372c15f2cbc6112f6a7d8094842cf57e86"

  bottle :unneeded

  depends_on "apache-spark"
  depends_on "elasticsearch"
  depends_on "hadoop"
  depends_on "hbase"
  depends_on :java => "1.8"

  def install
    rm_f Dir["bin/*.bat"]

    libexec.install Dir["*"]
    (bin/"pio").write_env_script libexec/"bin/pio", Language::Java.java_home_env("1.8")

    inreplace libexec/"conf/pio-env.sh" do |s|
      s.gsub! /#\s*ES_CONF_DIR=.+$/, "ES_CONF_DIR=#{Formula["elasticsearch"].opt_prefix}/config"
      s.gsub! /SPARK_HOME=.+$/, "SPARK_HOME=#{Formula["apache-spark"].opt_prefix}"
    end
  end
end
