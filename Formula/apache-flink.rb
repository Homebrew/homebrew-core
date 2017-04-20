class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https://flink.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=flink/flink-1.2.0/flink-1.2.0-bin-hadoop27-scala_2.11.tgz"
  version "1.2.0"
  sha256 "ccb37938fef54236252a3e895cdca63d881c6138515109b4ad4da2a0fb9b8ac8"
  head "https://github.com/apache/flink.git"

  bottle :unneeded

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/flink"]
  end

  test do
    ENV["_JAVA_OPTIONS"] = "-Djava.io.tmpdir=#{testpath} -Duser.home=#{testpath}"
    input = "benv.fromElements(1,2,3).print()\n"
    output = pipe_output("#{libexec}/bin/start-scala-shell.sh local", input, 1)
    assert_match "FINISHED", output
  end
end
