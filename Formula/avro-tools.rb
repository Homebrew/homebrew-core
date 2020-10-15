class AvroTools < Formula
  desc "Avro command-line tools and utilities"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.10.0/java/avro-tools-1.10.0.jar"
  mirror "https://archive.apache.org/dist/avro/avro-1.10.0/java/avro-tools-1.10.0.jar"
  sha256 "74c037354ba1bb43e07d336d46d95d54bc347f2d8073d7cf1087d447b5978a56"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle :unneeded

  def install
    libexec.install "avro-tools-#{version}.jar"
    bin.write_jar_script libexec/"avro-tools-#{version}.jar", "avro-tools"
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/avro-tools 2>&1", 1)
  end
end
