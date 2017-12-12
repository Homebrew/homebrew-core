class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https://flink.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=flink/flink-1.4.0/flink-1.4.0-bin-hadoop27-scala_2.11.tgz"
  version "1.4.0"
  sha256 "e334dd99bb20f14f4be789d8a38253815ee22bcc07defabf388c87d20c7935b4"
  head "https://github.com/apache/flink.git"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    (bin/"flink").write_env_script libexec/"bin/flink", Language::Java.java_home_env("1.8")
  end

  test do
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"
    input = "benv.fromElements(1,2,3).print()\n"
    output = pipe_output("#{libexec}/bin/start-scala-shell.sh local", input, 1)
    assert_match "FINISHED", output
  end
end
