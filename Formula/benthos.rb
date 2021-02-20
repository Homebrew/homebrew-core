class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.41.1.tar.gz"
  sha256 "17021798cde346a671bf58f91abb759252d8d11e4d680294dcfdc1f3b1228b1a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fc20f682dba98d34d7038df0042479a2aa4594ac9ff6953db09f7c3b6b8cbcd5"
    sha256 cellar: :any_skip_relocation, big_sur:       "d78f865de9506c62f1aa433c4b8fe2419c3c47531903fce35a099fe814705c50"
    sha256 cellar: :any_skip_relocation, catalina:      "a39c28d4224eef9f50589dd565e269d128db1ac21dd95cef1e2956a676559f27"
    sha256 cellar: :any_skip_relocation, mojave:        "ec305bbd5ba7e84339936896ffc821748a30d01106516636e89feb7fa7143d04"
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
