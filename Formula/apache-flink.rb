class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https://flink.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=flink/flink-1.0.2/flink-1.0.2-bin-hadoop26-scala_2.10.tgz"
  version "1.0.2"
  sha256 "a3d68b3d8d90c742f5a137daec1ea38c28ed6e8498f6e1b5430a54b4621ca989"
  head "https://github.com/apache/flink.git"

  bottle :unneeded

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/flink"]
  end

  test do
    ENV["_JAVA_OPTIONS"] = "-Djava.io.tmpdir=#{testpath} -Duser.home=#{testpath}"
    assert_match /FINISHED/, pipe_output("#{libexec}/bin/start-scala-shell.sh local", "env.fromElements(1,2,3).print()\n", 1)
  end
end
