class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org/"
  url "https://dlcdn.apache.org/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz"
  mirror "https://archive.apache.org/dist/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz"
  version "3.5.0"
  sha256 "ac064ec620129b4b9630e180e25ac2b71a8ccd4c6912bf5b5631943b742f0379"
  license "Apache-2.0"
  head "https://github.com/apache/spark.git", branch: "master"

  # The download page creates file links using JavaScript, so we identify
  # versions within the related JS file.
  livecheck do
    url "https://spark.apache.org/js/downloads.js"
    regex(/addRelease\(.*?["']v?(\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86def33303bb1a5c1b9dd388c50889402405166988a9376c94cb547e089c624b"
  end

  depends_on "openjdk@17"

  def install
    # Rename beeline to distinguish it from hive's beeline
    mv "bin/beeline", "bin/spark-beeline"

    rm_f Dir["bin/*.cmd"]
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
