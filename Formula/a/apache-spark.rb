class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org/"
  url "https://dlcdn.apache.org/spark/spark-3.5.3/spark-3.5.3-bin-hadoop3.tgz"
  mirror "https://archive.apache.org/dist/spark/spark-3.5.3/spark-3.5.3-bin-hadoop3.tgz"
  version "3.5.3"
  sha256 "173651a8a00f5bf0ee27b74d817e0e52eed9daa49fd66d59718994974d1d367d"
  license "Apache-2.0"
  head "https://github.com/apache/spark.git", branch: "master"

  # The download page creates file links using JavaScript, so we identify
  # versions within the related JS file.
  livecheck do
    url "https://spark.apache.org/js/downloads.js"
    regex(/addRelease\(.*?["']v?(\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "57a6975ec946b5e729579e522a0c5fd733a3f951c3ac47b0954805c573ffad13"
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
    assert_match "Long = 1000",
      pipe_output(bin/"spark-shell --conf spark.driver.bindAddress=127.0.0.1",
                  "sc.parallelize(1 to 1000).count()")
    assert_match "String = abi/trivial",
      pipe_output(bin/"spark-shell --conf spark.driver.bindAddress=127.0.0.1",
                  "jdk.incubator.foreign.FunctionDescriptor.TRIVIAL_ATTRIBUTE_NAME")
  end
end
