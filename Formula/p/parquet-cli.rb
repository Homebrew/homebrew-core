class ParquetCli < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-mr.git",
      tag:      "apache-parquet-1.14.0",
      revision: "fe9179414906cc19b550d13d2819b4e16fddf8a1"
  license "Apache-2.0"
  head "https://github.com/apache/parquet-mr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c2829a0f0cb3099a9cc71f7097d63c97afb7f21d149e066495797fa6a4632d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a835c27ba0f4b035c2dffab9c66cfeb75640a9ae60028d56fc18e81f874c6582"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f248fc5ce2c40e13bc966be98de481b747c4390d6eb35160d4134dce9ae27bf3"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4a97c973c26827e535a2fe0e614d83eb74a3e3e58aa11a0ac08e6f405ab6e30"
    sha256 cellar: :any_skip_relocation, ventura:        "bc6675c31fab9ef3912d7b6e43f77a56acc0d5047f25693378eea405554d219f"
    sha256 cellar: :any_skip_relocation, monterey:       "eb1ebad940b4bfe8048d0e82240342a3976d012c07c55eca50306b0c6bd45909"
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
