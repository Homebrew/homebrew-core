class Adam < Formula
  desc "Genomics analysis platform built on Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/adam/adam-distribution-spark2_2.11/0.22.0/adam-distribution-spark2_2.11-0.22.0-bin.tar.gz"
  sha256 "31624954eb473f2ec24354af7e6303a47887cf2ca4076bb71f54618aef59e15b"
  revision 1

  head do
    url "https://github.com/bigdatagenomics/adam.git", :shallow => false
    depends_on "maven" => :build
  end

  depends_on "apache-spark"

  def install
    if build.head?
      system "scripts/move_to_scala_2.11.sh"
      system "scripts/move_to_spark_2.sh"
      system "mvn", "clean", "package", "-DskipTests=True"
    end
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/adam-submit", "--version"
  end
end
