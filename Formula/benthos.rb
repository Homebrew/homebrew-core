class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.12.1.tar.gz"
  sha256 "aa8f082049714528a84515a74c126a3f2ab021dcf35d476bc8aff6623e29d017"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "413bf9a6fc6981dcd17f84ef0d7fe990dc7dfecf76ae615d685a050bff261002"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a7ebbef82fe958aec621ec95d5901bf06342726e2e5bc02eff6359f0af1b546"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d40d851f5e153836dd80c151eb28a76bd6a935c8b81843eaa7b2ffbd705d021a"
    sha256 cellar: :any_skip_relocation, ventura:        "14d7bab96e1cfcaf362aa288fddc5d11ff59f421813a777c0b7fc3a0802925de"
    sha256 cellar: :any_skip_relocation, monterey:       "36d8e483a4d7abc92d077a62d9e00e41e846dff5fce15df933792174b309a80b"
    sha256 cellar: :any_skip_relocation, big_sur:        "091e53f965e2f21b6c6b4496f1804690fadefdae41b13bb28848c6db2ef3dae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "671d2b7e7f01bb1903f9ea238dfbe94ea867b57257349fa2320d45ebdaae0706"
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
        file:
          paths: [ ./sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
