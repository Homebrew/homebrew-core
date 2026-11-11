class ParquetCli < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-java/archive/refs/tags/apache-parquet-1.18.2.tar.gz"
  sha256 "713252b84a1a1efb19bdaef1a36e8c2f49b7f2b4edc881f63f37e081a31c0938"
  license "Apache-2.0"
  head "https://github.com/apache/parquet-java.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8713f55ba235584eaf9f96d63bbb247307bd466c35f8c23cd79d352649f64b94"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8713f55ba235584eaf9f96d63bbb247307bd466c35f8c23cd79d352649f64b94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8713f55ba235584eaf9f96d63bbb247307bd466c35f8c23cd79d352649f64b94"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dce068d0bbfed40a698766c0d9fd393eb1f43044ee4caff0d60e9067f6d10d9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dce068d0bbfed40a698766c0d9fd393eb1f43044ee4caff0d60e9067f6d10d9e"
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
