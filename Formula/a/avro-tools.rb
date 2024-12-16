class AvroTools < Formula
  desc "Avro command-line tools and utilities"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.12.0/java/avro-tools-1.12.0.jar"
  mirror "https://archive.apache.org/dist/avro/avro-1.12.0/java/avro-tools-1.12.0.jar"
  sha256 "63b6c890a3aceba69c2ea7d2033c9d1e62d0837d13121b4ce01aea856f72a018"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "0c9a211ec08bf395ec8ee998b5ba200da009d31918e1046b8fc4560d8c6fb57a"
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
