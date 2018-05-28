class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https://flink.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=flink/flink-1.5.0/flink-1.5.0-bin-hadoop27-scala_2.11.tgz"
  version "1.5.0"
  sha256 "9a8232c124c80ea447cbc2c8edcaa0b4850aecaa9d506169c968777956ccd8ff"
  head "https://github.com/apache/flink.git"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    (libexec/"bin").env_script_all_files(libexec/"libexec", Language::Java.java_home_env("1.8"))
    chmod 0755, Dir["#{libexec}/bin/*"]
    bin.write_exec_script "#{libexec}/bin/flink"
  end

  test do
    log_dir = testpath/"log"
    mkdir log_dir
    input = "foo bar foobar"
    input_file = testpath/"input"
    IO.write(input_file, input)
    output_file = testpath/"result"
    expected_output = "(foo,1)\n(bar,1)\n(foobar,1)\n"
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"
    ENV.prepend "FLINK_LOG_DIR", log_dir.to_s
    shell_output("#{libexec}/bin/start-cluster.sh", 0)
    shell_output("#{bin}/flink run -p 1 #{libexec}/examples/streaming/WordCount.jar --input #{input_file} --output #{output_file}", 0)
    shell_output("#{libexec}/bin/stop-cluster.sh", 0)
    output = File.open(output_file).read
    assert_equal(expected_output, output)
  end
end
