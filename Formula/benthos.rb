class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.44.0.tar.gz"
  sha256 "c7cc44f2361fda9691c2efe74dbea54f577ce49798e4180ba9585173672e6634"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ee7786484541dc610ebf2447abcb5a1041783bd1ddb2a30a18e4834b54364e20"
    sha256 cellar: :any_skip_relocation, big_sur:       "80684f2e3f3d7b6347d071245949db8eff1d73078915e5f9483127cef4e13020"
    sha256 cellar: :any_skip_relocation, catalina:      "5e7f3ac9e9f5267b152bea9ce4e5178a8ed85d950a796316e659b654e312996a"
    sha256 cellar: :any_skip_relocation, mojave:        "5e1a2ad2b0a3e5dc704b4f4781c513af2613e21e540558232f803c149c1165d6"
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
