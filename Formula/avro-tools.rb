class AvroTools < Formula
  desc "Avro command-line tools and utilities"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.11.0/java/avro-tools-1.11.0.jar"
  mirror "https://archive.apache.org/dist/avro/avro-1.11.0/java/avro-tools-1.11.0.jar"
  sha256 "43ba8e1d63d6273e8ca72fee68b4125bfdbbbb3112ea0b021fa29d0c0d2f2276"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9af5531404a8b4749e116b605a0e9584cca51f180273a0cecf8f5e448aba6d61"
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
