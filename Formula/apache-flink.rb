class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https://flink.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=flink/flink-1.3.2/flink-1.3.2-bin-hadoop27-scala_2.11.tgz"
  version "1.3.2"
  sha256 "378be2346990264eeff2ae012175523fc94ddbe59bead7e2a76e0d93c0c7c455"
  head "https://github.com/apache/flink.git"

  bottle :unneeded

  depends_on :java => "1.7+"

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
