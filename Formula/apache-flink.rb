class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https://flink.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=flink/flink-1.11.1/flink-1.11.1-bin-scala_2.12.tgz"
  mirror "https://archive.apache.org/dist/flink/flink-1.11.1/flink-1.11.1-bin-scala_2.12.tgz"
  version "1.11.1"
  sha256 "187f5acdc1aafe580fec925465215f1b73d65a3ebc763c39c5ac16d270101eb1"
  license "Apache-2.0"
  head "https://github.com/apache/flink.git"

  livecheck do
    url :stable
  end

  bottle :unneeded

  depends_on java: "1.8"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    (libexec/"bin").env_script_all_files(libexec/"libexec", Language::Java.java_home_env("1.8"))
    (libexec/"bin").install Dir["#{libexec}/libexec/*.jar"]
    chmod 0755, Dir["#{libexec}/bin/*"]
    bin.write_exec_script "#{libexec}/bin/flink"
  end

  test do
    (testpath/"log").mkpath
    (testpath/"input").write "foo bar foobar"
    expected = <<~EOS
      (foo,1)
      (bar,1)
      (foobar,1)
    EOS
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"
    ENV.prepend "FLINK_LOG_DIR", testpath/"log"
    system libexec/"bin/start-cluster.sh"
    system bin/"flink", "run", "-p", "1",
           libexec/"examples/streaming/WordCount.jar", "--input", "input",
           "--output", "result/1"
    system libexec/"bin/stop-cluster.sh"
    assert_predicate testpath/"result/1", :exist?
    assert_equal expected, (testpath/"result/1").read
  end
end
