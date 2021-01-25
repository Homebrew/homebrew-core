class AvroTools < Formula
  desc "Avro command-line tools and utilities"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.10.1/java/avro-tools-1.10.1.jar"
  mirror "https://archive.apache.org/dist/avro/avro-1.10.1/java/avro-tools-1.10.1.jar"
  sha256 "172bf20f983ab82c785ccbc31504fa6e6c44f3e93b78c0f201c25ce990d671cb"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

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
