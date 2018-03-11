class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https://flink.apache.org/"
  url "http://www.apache.org/dyn/closer.lua?path=/flink/flink-1.4.1/flink-1.4.1-bin-scala_2.11.tgz"
  version "1.4.1"
  sha256 "71aef55d9438e08b1865e63fa5c4817fedfe4c97b4ca2552d20b6b7f1f39b891"
  head "https://github.com/apache/flink.git"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/flink"]
  end

  test do
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"
    input = "benv.fromElements(1,2,3).print()\n"
    output = pipe_output("#{libexec}/bin/start-scala-shell.sh local", input, 1)
    assert_match "FINISHED", output
  end
end
