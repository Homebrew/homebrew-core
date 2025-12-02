class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https://flink.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=flink/flink-2.1.1/flink-2.1.1-bin-scala_2.12.tgz"
  mirror "https://archive.apache.org/dist/flink/flink-2.1.1/flink-2.1.1-bin-scala_2.12.tgz"
  version "2.1.1"
  sha256 "5dfd2c7aca1aef09b33d9b53547d267836047048630ff61ad635b8464dd6805a"
  license "Apache-2.0"
  head "https://github.com/apache/flink.git", branch: "master"

  livecheck do
    url "https://flink.apache.org/downloads/"
    regex(/href=.*?flink[._-]v?(\d+(?:\.\d+)+)-bin[^"' >]*?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "befe2ca0024d319e984115d9be5ae58ecfe463a19b5d8a27c953440c7d2bc84d"
  end

  # Java 11, 17 (Default), and 21 are supported.
  # See: https://github.com/apache/flink?tab=readme-ov-file#building-apache-flink-from-source
  depends_on "openjdk@21"

  def install
    inreplace "conf/config.yaml" do |s|
      s.sub!(/^env:/, "env.java.home: #{Language::Java.java_home("21")}\n\\0")
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
