class ApacheFlinkAT1 < Formula
  desc "Scalable batch and stream data processing"
  homepage "https://flink.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=flink/flink-1.20.5/flink-1.20.5-bin-scala_2.12.tgz"
  mirror "https://archive.apache.org/dist/flink/flink-1.20.5/flink-1.20.5-bin-scala_2.12.tgz"
  version "1.20.5"
  sha256 "83305e28ee83bbac95ee26f08c42bc2df8a67bdb0259850f9078cca157b9a4e1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=["']?flink-v?(1(?:\.\d+)+)/}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fd12cd7ee56c5ad2e91726ae5cb9e3d99cdbee37771085ed378e5d6839b7735e"
  end

  keg_only :versioned_formula

  deprecate! date: "2026-05-02", because: :unsupported
  disable! date: "2027-05-02", because: :unsupported

  depends_on "openjdk@11"

  def install
    inreplace "conf/config.yaml" do |s|
      s.sub!(/^env:/, "env.java.home: #{Language::Java.java_home("11")}\n\\0")
    end
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/flink"
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
           "--output", testpath/"result"
    system libexec/"bin/stop-cluster.sh"
    assert_path_exists testpath/"result"
    result_files = Dir[testpath/"result/*/*"]
    assert_equal 1, result_files.length
    assert_equal expected, (testpath/result_files.first).read
  end
end
