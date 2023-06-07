class ParquetTools < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-mr.git",
      tag:      "apache-parquet-1.12.2",
      revision: "77e30c8093386ec52c3cfa6c34b7ef3321322c94"
  license "Apache-2.0"
  head "https://github.com/apache/parquet-mr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bccc742739150813fde729a1eb82b4cd122edeae186bbf2bc9845742d337a2f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97878dc311bf03733c98f0315c9ec1a077664e1d5687b6d8553ef31e2db39c52"
    sha256 cellar: :any_skip_relocation, monterey:       "74545f457e9f95a283f4a8bee126ab6cc05e79331c677a26db7fb2236076ffc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4384c7d5a32e1681340d393babb1fb59226b0a87c29f1643c71e23c4658bec90"
    sha256 cellar: :any_skip_relocation, catalina:       "40d62a070a0dcdc779e32f1054dd4bd2f220590a497d31c90c0230e653056c62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb10fb679729d2f61b8804013abb0a56aadaf14c5e81c644ade30123edd6c7a6"
  end

  # See https://issues.apache.org/jira/browse/PARQUET-1666
  disable! date: "2022-07-31", because: :deprecated_upstream

  depends_on "maven" => :build
  depends_on "openjdk"

  # This file generated with `red-parquet` gem:
  #   Arrow::Table.new("values" => ["foo", "Homebrew", "bar"]).save("homebrew.parquet")
  resource("test-parquet") do
    url "https://gist.github.com/bayandin/2144b5fc6052153c1a33fd2679d50d95/raw/7d793910a1afd75ee4677f8c327491f7bdd2256b/homebrew.parquet"
    sha256 "5caf572cb0df5ce9d6893609de82d2369b42c3c81c611847b6f921d912040118"
  end

  def install
    cd "parquet-tools-deprecated" do
      system "mvn", "clean", "package", "-Plocal", "-DskipTests=true"
      libexec.install "target/parquet-tools-deprecated-#{version}.jar"
      bin.write_jar_script libexec/"parquet-tools-deprecated-#{version}.jar", "parquet-tools"
    end
  end

  test do
    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools cat #{testpath}/homebrew.parquet")
    assert_match "values = Homebrew", output
  end
end
