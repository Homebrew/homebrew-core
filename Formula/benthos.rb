class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.55.0.tar.gz"
  sha256 "038ff6a9dfaa5b70e36abd968f9c420cb0ba167c39e71c11a54890335901e1e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2769777c0d61d15784c7a27194e5d95fc0dad08dd49ab23b6233cac940ebfa1a"
    sha256 cellar: :any_skip_relocation, big_sur:       "f57f29390918df536c86e03a33572a5695f8f04915daceef57bca9266edc74e9"
    sha256 cellar: :any_skip_relocation, catalina:      "90a7daa671f7bd165c7067b440dee2192cf3afc0d6501c8f4a350c80eff30406"
    sha256 cellar: :any_skip_relocation, mojave:        "e4a9ac5d3f749b7a92576b67f527d4a49763b3e665c15dba38630901e598d986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d2bf022e9e6eb2aabc1b78c16c98d3ec9d2091a1c5cd761af1d4d8f60b368c9"
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
