class ParquetCli < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-java/archive/refs/tags/apache-parquet-1.18.0.tar.gz"
  sha256 "2c1f8931177a01beeac7e0b87c53e693598a3157595ca6bf3fbb3bf4db9de2a8"
  license "Apache-2.0"
  head "https://github.com/apache/parquet-java.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca813e2df90bc4794cd113ca41691d57025a6b663b60c21ce785d072bba01503"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca813e2df90bc4794cd113ca41691d57025a6b663b60c21ce785d072bba01503"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca813e2df90bc4794cd113ca41691d57025a6b663b60c21ce785d072bba01503"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca813e2df90bc4794cd113ca41691d57025a6b663b60c21ce785d072bba01503"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef2d1724811e0051ad4d302b7802d058f1f2d3f172c490bd3d90739c1ecc8dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef2d1724811e0051ad4d302b7802d058f1f2d3f172c490bd3d90739c1ecc8dc9"
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
