class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.31.0.tar.gz"
  sha256 "0bdffe470ce7689924365af12de5f7fdc6f6ae3e0bb1980f3279f9c8c0e1b462"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "205a6bd35acba7d2078d7677685f2acda241c8c3f7a74282f77b51d81d1d2b59" => :catalina
    sha256 "0dc091b47c77cec25f3b0542593a296c2ecd455d9f44d1c8210cd148655bfda1" => :mojave
    sha256 "32ef83bc233c09a1b476ab9d7c514f5bdee1c40b69f82cf64a96a041de34197c" => :high_sierra
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
