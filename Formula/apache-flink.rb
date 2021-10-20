class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https://flink.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=flink/flink-1.14.0/flink-1.14.0-bin-scala_2.12.tgz"
  mirror "https://archive.apache.org/dist/flink/flink-1.14.0/flink-1.14.0-bin-scala_2.12.tgz"
  version "1.14.0"
  sha256 "3dfac757f3da1d8b09c8697008aaad2bbf4ecee24d9672cfcdbe799711b6501f"
  license "Apache-2.0"
  head "https://github.com/apache/flink.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "90b48eae1d48b23bee7b4a42dd4ab369c4b0e664257903db785cc8107118ee69"
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
