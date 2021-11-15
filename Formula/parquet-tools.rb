class ParquetTools < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-mr.git",
      tag:      "apache-parquet-1.12.0",
      revision: "db75a6815f2ba1d1ee89d1a90aeb296f1f3a8f20"
  license "Apache-2.0"
  head "https://github.com/apache/parquet-mr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a0b30e5039eff7d29fd1ddfd8e8d840b23077005d7fb512144f0aaa0708f075"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72bdfcf0a71023b65def0a02b1b581ba7a9b228ea5a1594923fddb2d1eb098d6"
    sha256 cellar: :any_skip_relocation, monterey:       "6eab85ecd2c97e14364443687196750c0cde7dac5733eb13805d866a086b462a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c84021c2e6e9475380715420dec0edc741c59edb525e197a1c355fd3679187e6"
    sha256 cellar: :any_skip_relocation, catalina:       "0bb7bd347b698537ef9b8690648aa6b13c328fd3c60eec5c6614b94c8d770835"
    sha256 cellar: :any_skip_relocation, mojave:         "17e6ad97c0d0fcab7989305eabd2b853cdc694f059f29d36cda5d94422de4e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c27c4802070eea520a2a140569b8f0ec16591786caf4b87c7e8ccb9ee9414d15"
  end

  # See https://issues.apache.org/jira/browse/PARQUET-1666
  deprecate! date: "2021-03-25", because: :deprecated_upstream

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
