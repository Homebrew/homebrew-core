class ParquetCli < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-java/archive/refs/tags/apache-parquet-1.18.1.tar.gz"
  sha256 "8c93ac92bd76f2167154ededcdb79b32d4725d9d940f9fedc84bef5103912546"
  license "Apache-2.0"
  head "https://github.com/apache/parquet-java.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "640e1ff30cd9de6f90dfea5e500f610c179bb5534e38d8714247250172085c44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "640e1ff30cd9de6f90dfea5e500f610c179bb5534e38d8714247250172085c44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "640e1ff30cd9de6f90dfea5e500f610c179bb5534e38d8714247250172085c44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb1a7c3d2e5b1ad48fbd06c7e83554d1a9e2cc9b773c13abbbb321353ea7859a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb1a7c3d2e5b1ad48fbd06c7e83554d1a9e2cc9b773c13abbbb321353ea7859a"
  end

  depends_on "maven" => :build
  # Try switching back to `openjdk` when the issue below is resolved and
  # Hadoop dependency is updated to include the fix/workaround.
  # https://issues.apache.org/jira/browse/HADOOP-19212
  depends_on "openjdk@21"

  def install
    cd "parquet-cli" do
      system "mvn", "clean", "package", "-DskipTests=true"
      system "mvn", "dependency:copy-dependencies"
      libexec.install "target/parquet-cli-#{version}.jar"
      libexec.install Dir["target/dependency/*"]
      (bin/"parquet").write <<~SH
        #!/bin/sh
        set -e
        exec "#{formula_opt_bin("openjdk@21")}/java" -cp "#{libexec}/*" org.apache.parquet.cli.Main "$@"
      SH
    end

    (pkgshare/"test").install "parquet-avro/src/test/avro/stringBehavior.avsc"
    (pkgshare/"test").install "parquet-avro/src/test/resources/strings-2.parquet"
  end

  test do
    output = shell_output("#{bin}/parquet schema #{pkgshare}/test/stringBehavior.avsc")
    assert_match <<~EOS, output
      {
        "type" : "record",
        "name" : "StringBehaviorTest",
        "namespace" : "org.apache.parquet.avro",
        "fields" : [ {
          "name" : "default_class",
          "type" : "string"
        }, {
    EOS

    output = shell_output("#{bin}/parquet schema #{pkgshare}/test/strings-2.parquet")
    assert_match <<~EOS, output
      {
        "type" : "record",
        "name" : "mystring",
        "fields" : [ {
          "name" : "text",
          "type" : "string"
        } ]
      }
    EOS
  end
end
