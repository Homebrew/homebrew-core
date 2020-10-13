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
    sha256 "37d87045919ddb7d3f85efd0ad02b2af90b2f6bdb850da7e917b05c0e622aad0" => :catalina
    sha256 "ebcc402a4b4385cec57dc835142940ceab8233809ff99311ca04a3a81e22a1c4" => :mojave
    sha256 "e86151377d7008b1674f4cc71b11aabea81d4e2ce3c04b10e90bf197bc36c021" => :high_sierra
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
