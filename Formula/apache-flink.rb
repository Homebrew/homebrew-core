class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https://flink.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=flink/flink-1.1.4/flink-1.1.4-bin-hadoop27-scala_2.11.tgz"
  version "1.1.4"
  sha256 "654ffcf0bc8f0bce6dc5c203c0d37243d6ad35db4fdce574c72430652cb8c7ab"
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
