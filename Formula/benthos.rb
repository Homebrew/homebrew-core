class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.52.0.tar.gz"
  sha256 "59957c0e479f11ece25c8fc6a88e484ef7e2fd226e16c6a4663058eed7a29982"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8da70474b873cbbd9c402e79aa236e4d6a627c703fdae1c474a0af52ba3e3915"
    sha256 cellar: :any_skip_relocation, big_sur:       "75306ed5f9cd6c5b2db1b574f462d5c4ffd185ebbba82c2ed1739cc7d0a1af11"
    sha256 cellar: :any_skip_relocation, catalina:      "c8a0ac550002f943ac50cb848bcf173b035325a61113d020a99ddbf57bd2055d"
    sha256 cellar: :any_skip_relocation, mojave:        "99a1266ee234a44c52372ca790a60f5c69199a5b683f0d8b0c1540f51ef5afba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f347989e53534640db575f01af9044f68dc12853e8dccc81301768e4156f1a8"
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
