class ApacheZeppelin < Formula
  desc "Multi-purpose Notebook supporting Spark, Cassandra etc..."
  homepage "https://zeppelin.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=zeppelin/zeppelin-0.6.1/zeppelin-0.6.1-bin-all.tgz"
  sha256 "5185952361d1999fb3c00b8aca2c6ddc57353af5a1fd93f4f5b9dd89c7222147"
  head "https://github.com/apache/zeppelin.git"

  bottle :unneeded

  def install
    rm_f Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/zeppelin-daemon.sh", "--version"
  end
end
