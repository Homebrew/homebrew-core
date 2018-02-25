class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https://flink.apache.org/"
  url "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=flink/flink-1.4.0/flink-1.4.0-bin-scala_2.11.tgz"
  version "1.4.0"
  sha256 "a6cee77e0719c42f0bd2d30e5a149a71ad50a708f163605c4570d418ba6c0035"
  head "https://github.com/apache/flink.git"

  bottle :unneeded

  # Upstream support for Java9 comes in version 1.5: https://issues.apache.org/jira/browse/FLINK-8033
  # Upstream support for Scala 2.12 comes in version 1.5: https://issues.apache.org/jira/browse/FLINK-7811
  depends_on :java => "1.8"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    (bin/"flink").write_env_script "#{libexec}/bin/flink", Language::Java.java_home_env("1.8")
  end

  test do
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"
    input = "benv.fromElements(1,2,3).print()\n"
    output = pipe_output("#{libexec}/bin/start-scala-shell.sh local", input, 1)
    assert_match "FINISHED", output
  end
end
