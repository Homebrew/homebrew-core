class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org/"
  url "https://dlcdn.apache.org/spark/spark-3.5.5/spark-3.5.5-bin-hadoop3.tgz"
  mirror "https://archive.apache.org/dist/spark/spark-3.5.5/spark-3.5.5-bin-hadoop3.tgz"
  version "3.5.5"
  sha256 "8daa3f7fb0af2670fe11beb8a2ac79d908a534d7298353ec4746025b102d5e31"
  license "Apache-2.0"
  head "https://github.com/apache/spark.git", branch: "master"

  # The download page creates file links using JavaScript, so we identify
  # versions within the related JS file.
  livecheck do
    url "https://spark.apache.org/js/downloads.js"
    regex(/addRelease\(.*?["']v?(\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ee6cf6111d441cd77534189b45edf345a560aff75a2a547ea223d3ccb613f2af"
  end

  depends_on "openjdk@17"

  def install
    # Rename beeline to distinguish it from hive's beeline
    mv "bin/beeline", "bin/spark-beeline"

    rm(Dir["bin/*.cmd"])
    libexec.install Dir["*"]
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Language::Java.overridable_java_home_env("17")[:JAVA_HOME])
  end

  test do
    command = "#{bin}/spark-shell --conf spark.driver.bindAddress=127.0.0.1"
    trivial_attribute_name = "jdk.incubator.foreign.FunctionDescriptor.TRIVIAL_ATTRIBUTE_NAME"
    assert_match "Long = 1000", pipe_output(command, "sc.parallelize(1 to 1000).count()", 0)
    assert_match "String = abi/trivial", pipe_output(command, trivial_attribute_name, 0)
  end
end
