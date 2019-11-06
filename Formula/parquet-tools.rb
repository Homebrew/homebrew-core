class ParquetTools < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-mr.git",
      :tag      => "apache-parquet-1.10.0",
      :revision => "031a6654009e3b82020012a18434c582bd74c73a"
  head "https://github.com/apache/parquet-mr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "663df850056a24973c7a164823fe859efdd8b1b84bc5b622f12f2922bcad5eb8" => :catalina
    sha256 "80bbeb4f549cb06c1195fbd4b9170a428cf435678a579d1437d9b7f5fc0399da" => :mojave
    sha256 "727a15da8f38f3a9accf1b5850e98c12a6b783d97014826442421eb2b25a1006" => :high_sierra
    sha256 "9d0889dcab15c776d2878796562ec41a8e4baf539996e51714180138cb005c15" => :sierra
    sha256 "5847b83a96097c31497caf966d3d28185b16912bb4017bfbc4a2dd284b3c350d" => :el_capitan
  end

  depends_on "maven" => :build

  def install
    cd "parquet-tools" do
      system "mvn", "clean", "package", "-Plocal"
      libexec.install "target/parquet-tools-#{version}.jar"
      bin.write_jar_script libexec/"parquet-tools-#{version}.jar", "parquet-tools"
    end
  end

  test do
    system "#{bin}/parquet-tools", "cat", "-h"
  end
end
