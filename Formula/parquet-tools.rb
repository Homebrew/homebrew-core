class ParquetTools < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-mr.git",
      tag:      "apache-parquet-1.11.1",
      revision: "765bd5cd7fdef2af1cecd0755000694b992bfadd"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/parquet-mr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c92af57c5d3e5df830feb8143737a6bddbe986169a80b6457fbd725c7509d06" => :big_sur
    sha256 "d9b85d31e4b7d62fe66178eb6e1c16f1ef21672cdefee382492eee1a30cc5934" => :arm64_big_sur
    sha256 "9a8d696b41cd9b0c06a79aefeab6f1c8dd3124dec409390563adc2a2976e3a9b" => :catalina
    sha256 "90f8b4dc30bb841afe9a1e1654d95a4e7fe6fd3338196ea7c82e503c8a88b1d8" => :mojave
    sha256 "3fba4dc621d0ddb6e8cb648dba43398d98e37e0f954130353f368b6f849e6f06" => :high_sierra
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  # This file generated with `red-parquet` gem:
  #   Arrow::Table.new("values" => ["foo", "Homebrew", "bar"]).save("homebrew.parquet")
  resource("test-parquet") do
    url "https://gist.github.com/bayandin/2144b5fc6052153c1a33fd2679d50d95/raw/7d793910a1afd75ee4677f8c327491f7bdd2256b/homebrew.parquet"
    sha256 "5caf572cb0df5ce9d6893609de82d2369b42c3c81c611847b6f921d912040118"
  end

  # based on https://github.com/apache/parquet-mr/pull/809
  patch do
    url "https://github.com/apache/parquet-mr/commit/b6d07ae0744ba47aa9a8868ef2d7cbb232a60b22.patch?full_index=1"
    sha256 "200999012f743454cd525572bf848cd48b26051916a2d468474823a0aa2ccf61"
  end

  def install
    # Mimic changes from https://github.com/apache/parquet-mr/pull/826
    # See https://issues.apache.org/jira/browse/PARQUET-1923
    inreplace "pom.xml", "<hadoop.version>2.7.3</hadoop.version>", "<hadoop.version>2.10.1</hadoop.version>"

    cd "parquet-tools" do
      system "mvn", "clean", "package", "-Plocal"
      libexec.install "target/parquet-tools-#{version}.jar"
      bin.write_jar_script libexec/"parquet-tools-#{version}.jar", "parquet-tools"
    end
  end

  test do
    resource("test-parquet").stage(testpath)
    system "#{bin}/parquet-tools", "cat", testpath/"homebrew.parquet"

    output = shell_output("#{bin}/parquet-tools cat #{testpath}/homebrew.parquet")
    assert_match "values = Homebrew", output
  end
end
