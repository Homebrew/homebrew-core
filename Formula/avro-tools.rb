class AvroTools < Formula
  desc "Avro command-line tools and utilities"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.10.2/java/avro-tools-1.10.2.jar"
  mirror "https://archive.apache.org/dist/avro/avro-1.10.2/java/avro-tools-1.10.2.jar"
  sha256 "ab158f4af8f767d2358a29d8678939b2a0f96017490acfb4e7ed0708cea07913"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "avro-tools-#{version}.jar"
    bin.write_jar_script libexec/"avro-tools-#{version}.jar", "avro-tools"
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/avro-tools 2>&1", 1)
  end
end
