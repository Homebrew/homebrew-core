class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.44.1.tar.gz"
  sha256 "01f1916da2c35f571bdf5d7c9541be41429a898325ee4363841a753bf4125e85"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62a68dd52c702883e01053c9def596913a64d7dad0fbf2500f3d5148f4556d54"
    sha256 cellar: :any_skip_relocation, big_sur:       "f2db35835763a36f0f2cfea29192b247f2006403ed6d204253ef007031fe8692"
    sha256 cellar: :any_skip_relocation, catalina:      "2b85ea01a162bc287898fd6555116441e334c49e965a92dd177fc18a35b62fc0"
    sha256 cellar: :any_skip_relocation, mojave:        "a024a1086f9646ea53a7dc4313b2b0c484f7cd4f439d8d3d9daa05a60f435bb1"
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
