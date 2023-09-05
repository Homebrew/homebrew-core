class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/refs/tags/v4.20.0.tar.gz"
  sha256 "191610633e4016af954bc8bf69f41c42526f150e52395bd58cd08c25e0cb94d1"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c0670219ff3c0a2bd6b21ce5005910a7fbfe028ca611bbae1305958ec075384"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3f8adfd5a8b421edb3519f35a18d884dc66966efbbb1e75db8da3f6bf4a3748"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70886d6253b55f619db7d0f963e44fcaf53289f3744aa279dc823c58f19356c7"
    sha256 cellar: :any_skip_relocation, ventura:        "a23832bd49a7efde281bfeec6d242a0740165c69b2598d191b8bcb0b05ddc251"
    sha256 cellar: :any_skip_relocation, monterey:       "8d893dc5df40ae683fc1a147225e4c4bd8a9a93ede3f44554383f292c87e6d76"
    sha256 cellar: :any_skip_relocation, big_sur:        "97c07098f2eda9dfdf9bb098f268a52b71bf3cebffa0be4ac874ccd09b22ae13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82605a480e16e8abae64120dbcf39b32694a0f756d0b6b66a3020ee5eb3f5227"
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
