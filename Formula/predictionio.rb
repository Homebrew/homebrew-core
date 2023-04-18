class Predictionio < Formula
  desc "Source machine learning server"
  homepage "https://predictionio.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=predictionio/0.14.0/apache-predictionio-0.14.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/predictionio/0.14.0/apache-predictionio-0.14.0-bin.tar.gz"
  sha256 "049c9147ad9a6e2beddc2befcac5c73071845b2150c05a71118164c975de6ed7"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "483dfcfe76371f6e4ecc93cd47c905cddce97b0db57c015cefa3fda6dbc80392"
  end

  # Original deprecation date: 2020-09-01
  disable! date: "2022-05-25", because: :unmaintained

  depends_on "apache-spark"
  depends_on "elasticsearch@6"
  depends_on "hadoop"
  depends_on "hbase"
  depends_on "openjdk@8"

  def install
    rm_f Dir["bin/*.bat"]

    libexec.install Dir["*"]
    (bin/"pio").write_env_script libexec/"bin/pio", Language::Java.java_home_env("1.8")

    inreplace libexec/"conf/pio-env.sh" do |s|
      s.gsub!(/#\s*ES_CONF_DIR=.+$/, "ES_CONF_DIR=#{Formula["elasticsearch@6"].opt_prefix}/config")
      s.gsub!(/SPARK_HOME=.+$/, "SPARK_HOME=#{Formula["apache-spark"].opt_prefix}")
    end
  end
end
