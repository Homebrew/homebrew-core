class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.44.1.tar.gz"
  sha256 "01f1916da2c35f571bdf5d7c9541be41429a898325ee4363841a753bf4125e85"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b8fbfdd77c61c2286dc23c20e215b6942a8c8cd8182c4c2aac1089741697298c"
    sha256 cellar: :any_skip_relocation, big_sur:       "e86b590065c47dcd1c1c9c5ace5a0c825d36d28106cc48b7d5baaf85c84aee56"
    sha256 cellar: :any_skip_relocation, catalina:      "04754d891224be6ae4312a5dc715ea904854285294c167fa4c9ca267a8860b88"
    sha256 cellar: :any_skip_relocation, mojave:        "fe150ab7cd45f4ec33423940f6831cbd992eb45dfc109b54aea922082abb1fdf"
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
