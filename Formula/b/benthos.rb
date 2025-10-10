class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.57.1.tar.gz"
  sha256 "05675ce43be80bd2d5694f9f701d929349b49b96688e6b1ef9519461e59c6223"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d3871c4ba7a7e9577eeafe34628ee9649740162976f2be28f23ae0baf406062"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d3871c4ba7a7e9577eeafe34628ee9649740162976f2be28f23ae0baf406062"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d3871c4ba7a7e9577eeafe34628ee9649740162976f2be28f23ae0baf406062"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3155ae3e5c731f215e0e6c26879378190b6712ae32d4cb1ef4bfa76b8a8605a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ac8824967f5c85fc30823a1b46679a9023cc044b20f14748f0705b523809cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e99ebeb8a7b9ba26790b1579adfd99e3376381c9944a7854574e68a34774e16f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~YAML
      ---
      logger:
        level: ERROR
      input:
        file:
          paths: [ ./sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    YAML
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
