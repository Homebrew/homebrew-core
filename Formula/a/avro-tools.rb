class AvroTools < Formula
  desc "Avro command-line tools and utilities"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.11.2/java/avro-tools-1.11.2.jar"
  mirror "https://archive.apache.org/dist/avro/avro-1.11.2/java/avro-tools-1.11.2.jar"
  sha256 "b8f2fb2a7e7e2cf734eaaa56b4b730be6d9efd73b5a4f0bc95f38944b8883fec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c4dc1a7ac00b8a93c0e1b3dd863a3febd200481b1c181760e758b31b310e346"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c4dc1a7ac00b8a93c0e1b3dd863a3febd200481b1c181760e758b31b310e346"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c4dc1a7ac00b8a93c0e1b3dd863a3febd200481b1c181760e758b31b310e346"
    sha256 cellar: :any_skip_relocation, ventura:        "6c4dc1a7ac00b8a93c0e1b3dd863a3febd200481b1c181760e758b31b310e346"
    sha256 cellar: :any_skip_relocation, monterey:       "6c4dc1a7ac00b8a93c0e1b3dd863a3febd200481b1c181760e758b31b310e346"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c4dc1a7ac00b8a93c0e1b3dd863a3febd200481b1c181760e758b31b310e346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be9d8acd4a357b1f9ee3eb77a8eb5db5bbd20cfd838c97de0474b86da031a64c"
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
