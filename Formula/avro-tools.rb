class AvroTools < Formula
  desc "Avro command-line tools and utilities"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.11.1/java/avro-tools-1.11.1.jar"
  mirror "https://archive.apache.org/dist/avro/avro-1.11.1/java/avro-tools-1.11.1.jar"
  sha256 "b954e75976c24b72509075b1a298b184db9efe2873bee909d023432f9826db88"
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
