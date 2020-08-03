class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.24.1.tar.gz"
  sha256 "459d5cba4c29ff049de4e19dfad7417a840c97887c85ff00f01367516372f762"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "33583596da9e80ab69bc5ab16c67e82ad58839db237309adb303bb6115fdd88b" => :catalina
    sha256 "f143a8973d4d370c05a416165ed387eff8030f2e81ff9525da354d535dcc15e5" => :mojave
    sha256 "daad1e26244d2141fc045cded8c7943fe3feaf8d2c6b857b5b3a97a83d9e71ad" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "target/bin/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~EOS
      ---
      logger:
        level: ERROR
      input:
        type: file
        file:
          path: ./sample.txt
      pipeline:
        threads: 1
        processors:
         - type: decode
           decode:
             scheme: base64
      output:
        type: stdout
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
