class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.58.0.tar.gz"
  sha256 "a7a71f3dff5d3b9e3acefe66a553f61b75bbd4ce98fad32a2c4a178bb6d20587"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b68129433cc98184e222cf743669eca889ad3e570a9cc6ca543d1c1e2fc5f9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d9efdbf949e17f07f065628add8489718064aafb81132ef7f156865e98cc450"
    sha256 cellar: :any_skip_relocation, monterey:       "09369b459bb3c555436984127775cc394b4050cdb1f1d13485ad7a5e10626def"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c023e4686cdff023c6a7c6aceaff38ec75259648820af25d180efe23dacd7a2"
    sha256 cellar: :any_skip_relocation, catalina:       "18acd8c49761bd6a1d2c22e90fef20dc4b72de9ce4a42337c9b1b23cd3142cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c159f110a7e3fc3d78a3464e0e90679692af58a429cf75a86349341d69357928"
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
