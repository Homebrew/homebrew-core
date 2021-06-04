class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https://flink.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=flink/flink-1.13.1/flink-1.13.1-bin-scala_2.12.tgz"
  mirror "https://archive.apache.org/dist/flink/flink-1.13.1/flink-1.13.1-bin-scala_2.12.tgz"
  version "1.13.1"
  sha256 "e644c2479afd94a7460d541f727849a2bef844e97a6133c614c3cb9a68a29438"
  license "Apache-2.0"
  head "https://github.com/apache/flink.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a52f82db10ddd60b183ed75873a4b18eab16cc9c7327debbc3b7eb57585943ba"
  end

  depends_on "openjdk@11"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    (libexec/"bin").env_script_all_files(libexec/"libexec", Language::Java.java_home_env("11"))
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
           libexec/"examples/streaming/WordCount.jar", "--input", testpath/"input",
           "--output", testpath/"result/1"
    system libexec/"bin/stop-cluster.sh"
    assert_predicate testpath/"result/1", :exist?
    assert_equal expected, (testpath/"result/1").read
  end
end
