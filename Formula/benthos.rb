class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.65.0.tar.gz"
  sha256 "da218fde33286b6f0ab2c2303f3ce773c7fb4cf9fee2f44929743405e6621f19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4743204b292f0bc34c4802a88fe92a2f72059116828d922c49e03373b3de4879"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bf947e213021e4694cbb813a16eff41d9b76a09a6769e6cdf8c5ade36898e25"
    sha256 cellar: :any_skip_relocation, monterey:       "88d91cad2bb5f686d8d5d7505553f7bf951597b6dcadbe85265c33666ff96c2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a3f17f84683b035a77eb6124443da892efd0ee662a75638725681acdd3c1bc9"
    sha256 cellar: :any_skip_relocation, catalina:       "37a1dfc2461f3def50296d75bb6b47671a9b27c28f28502fe1160ab3c809b0cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d338357f0e82967affff0bc67de161b820cdff7eeafcecd12548eb7babc13115"
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
