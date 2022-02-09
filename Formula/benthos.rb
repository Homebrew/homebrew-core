class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.63.0.tar.gz"
  sha256 "8e0bd572dfb2508dee4fd3398eecd16908910aec0607a148d7f94ef2ac3f4f0d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "483ea8feca0c0420ce4ebc217ab2a4feea1954bd1c280a9009c1dc93ce461cdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "394f317259ca7e78b2db99a5ad7d5bd6cd7839a0459b49d415d568c90dc56615"
    sha256 cellar: :any_skip_relocation, monterey:       "cff687f39a0e3380335364a8a1c561b288cb6fa702e01b7b1e596d64f4d661f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d92cec9ade2b2d615a3fc04c704f279cd02c553cf9513c913513dc5d23c67cc"
    sha256 cellar: :any_skip_relocation, catalina:       "538e900b32f176f4eb2467e58b58fc9c697ff7daa5f0b52654211b2be93bf540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebf5ab8ecf933323230e26aec1957f3735a48d8b7328871fdee575d6b4f14b36"
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
