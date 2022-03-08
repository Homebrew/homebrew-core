class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.65.0.tar.gz"
  sha256 "da218fde33286b6f0ab2c2303f3ce773c7fb4cf9fee2f44929743405e6621f19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f38a2825af65549c9b512d57c9fb1128229f94b466288722f527e5747b31e3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7150b668afe0770bd043e2b08213a80e545e51ad4d3c00660aae0e47f20f33e8"
    sha256 cellar: :any_skip_relocation, monterey:       "6097fee102b40bc991e9218a50e3a6613024893eca42c75faa8804deaacc2281"
    sha256 cellar: :any_skip_relocation, big_sur:        "91511f9bca271dd303d1477ee1b6f05cc0c90b2d3d628d4532c7eaa11710b63c"
    sha256 cellar: :any_skip_relocation, catalina:       "953b275b42a245b3a3857d9e236f65c788c7d51442cece4b562475e2f039d57f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c2cd02b49171595b9090d03b90c7a56591e8a34b0e2eade4b1cd97077c8ce4b"
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
