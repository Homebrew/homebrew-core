class ParquetTools < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-mr.git",
      :tag => "apache-parquet-1.9.0",
      :revision => "38262e2c80015d0935dad20f8e18f2d6f9fbd03c"
  head "https://github.com/apache/parquet-mr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4759d5a7d777828b8fd59182b3436cef50933927d99b12fc55a0e8f5edaf8e62" => :sierra
    sha256 "fcb4bd168264a7c7703443c1441e4bb24a1f6c0f161f96879b31cfb867091473" => :el_capitan
    sha256 "92bd9e54d5e447504dc61b51520bcce62f325f9aee09e3aac580b15a0fc4734e" => :yosemite
  end

  depends_on "maven" => :build

  def install
    ENV.java_cache
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
