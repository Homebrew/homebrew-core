class ParquetCli < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-mr.git",
      tag:      "apache-parquet-1.14.1",
      revision: "97ede968377400d1d79e3196636ba3de392196ba"
  license "Apache-2.0"
  head "https://github.com/apache/parquet-mr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4921c5a0099f3b55f007e97ae1ad4492260025ebb813de235faa234c84746fa8"
  end

  depends_on "maven" => :build

  # parquet-cli has problems running on Linux, for more information:
  # https://github.com/Homebrew/homebrew-core/pull/94318#issuecomment-1049229342
  depends_on :macos

  depends_on "openjdk"

  def install
    cd "parquet-cli" do
      system "mvn", "clean", "package", "-DskipTests=true"
      system "mvn", "dependency:copy-dependencies"
      libexec.install "target/parquet-cli-#{version}-runtime.jar"
      libexec.install Dir["target/dependency/*"]
      (bin/"parquet").write <<~EOS
        #!/bin/sh
        set -e
        exec "#{Formula["openjdk"].opt_bin}/java" -cp "#{libexec}/*" org.apache.parquet.cli.Main "$@"
      EOS
    end

    (pkgshare/"test").install "parquet-avro/src/test/avro/stringBehavior.avsc"
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
  end
end
