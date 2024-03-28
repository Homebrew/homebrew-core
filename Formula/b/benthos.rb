class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/refs/tags/v4.26.0.tar.gz"
  sha256 "39b62db2429e6c74d1876bf0fdf56fe70a5fdba040d7aae48db9e01f495e25bf"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff7421fbdd25a7cab4cf0614e0404c224f27fd601fe4a193510037573e2087f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05519909c4690c4887bcf43059e2b7dfd9a043d29b324fe5d27d0b782db4a384"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af82eb77ba45c12dc203a4b8bf83c6c95da438b940a6808fb6099d3135cd3025"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdf93aec092d7e68b112f281e10af217389c7686cd46ce5886c7ebdbb2cb417e"
    sha256 cellar: :any_skip_relocation, ventura:        "f1237d1f097953badd14115782696d49d65e81bcb3757c3a2e3b082eefe8eda4"
    sha256 cellar: :any_skip_relocation, monterey:       "cc8c522f754d294a87b31717f11cdfcc05cbf8f33abad4c6467e0a2dbd0a631d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acea695e3eccabe8d37cc865b136949b5d763041ffe34af5aaeeb2c0e4ca3cef"
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
