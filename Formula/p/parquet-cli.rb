class ParquetCli < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-java/archive/refs/tags/apache-parquet-1.17.1.tar.gz"
  sha256 "bf68ed249a828213e4b18de8de3865e2f4edbb856cd19057b2f559a7c9e8f1e5"
  license "Apache-2.0"
  head "https://github.com/apache/parquet-mr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0ec4ebffdd2db0ca29909d274ec16053efaf7f9cb5b58bcff8a6c56888332c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0ec4ebffdd2db0ca29909d274ec16053efaf7f9cb5b58bcff8a6c56888332c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0ec4ebffdd2db0ca29909d274ec16053efaf7f9cb5b58bcff8a6c56888332c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0ec4ebffdd2db0ca29909d274ec16053efaf7f9cb5b58bcff8a6c56888332c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d6f93054a0d02382f1481ea9b86e42d9d2c969b7241ce45654475f4edbab604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d6f93054a0d02382f1481ea9b86e42d9d2c969b7241ce45654475f4edbab604"
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
      (bin/"parquet").write <<~EOS
        #!/bin/sh
        set -e
        exec "#{Formula["openjdk@21"].opt_bin}/java" -cp "#{libexec}/*" org.apache.parquet.cli.Main "$@"
      EOS
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
