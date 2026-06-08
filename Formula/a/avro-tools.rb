class AvroTools < Formula
  desc "Avro command-line tools and utilities"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.12.1/java/avro-tools-1.12.1.jar"
  mirror "https://archive.apache.org/dist/avro/avro-1.12.1/java/avro-tools-1.12.1.jar"
  sha256 "eb269df172ec96f6721bf9e56182e28afd9cd72d596d035c46561f6f70a69c36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "38d023c2825177abcf6afefb16f1806b2655da255ea6ecb664d45047e1973fac"
  end

  depends_on "openjdk"

  def install
    libexec.install "avro-tools-#{version}.jar"
    bin.write_jar_script libexec/"avro-tools-#{version}.jar", "avro-tools"
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/avro-tools 2>&1", 1)
  end
end
