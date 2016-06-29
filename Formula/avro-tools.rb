class AvroTools < Formula
  desc "Avro command-line tools and utilities"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.8.1/java/avro-tools-1.8.1.jar"
  sha256 "3afcf3252596d48cf04569fdcb04d705bf4310479b10b84f11b9d9cdfd00033b"

  bottle :unneeded

  def install
    libexec.install "avro-tools-#{version}.jar"
    bin.write_jar_script libexec/"avro-tools-#{version}.jar", "avro-tools"
  end
end
