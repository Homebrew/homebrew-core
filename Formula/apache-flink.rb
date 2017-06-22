class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https://flink.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=flink/flink-1.3.0/flink-1.3.0-bin-hadoop27-scala_2.11.tgz"
  version "1.3.0"
  sha256 "a4e2f98605233999d018b5950ba7172e38fc2e3be30196e1fe13af5ea8856a45"
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
