class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.16.0.tar.gz"
  sha256 "54906dd1300ca1dc359ef80376c1375395b1a6a0eba0c3f0f601d08f25eebafd"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e7fa31dfcf36a0accafc722b69af29ec4fbfd854dd0b08f0ddf5084141c6b20b" => :catalina
    sha256 "75f3bfc071bc025627bf4e911fec5e29d37684b336e0f08befab68d26c00ed81" => :mojave
    sha256 "2f8378c466ae7e7f136c27fe63a1bf59743ed319327384f8ee9e644445cc6092" => :high_sierra
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
