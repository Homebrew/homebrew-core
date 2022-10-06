class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.9.1.tar.gz"
  sha256 "e5cbbfb3676d1b4d2dd4e93b64e6f2a1d18917f852ec8cce26f2a37a9ad82527"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6beb4a71bfd22a15c5ac5c2e6dff2d5eec8ccebfbc74575c5a7e2ab3da6200b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8835f9d1b3a986451fb05c72e906b42a55755e72a8d78816955c4ac038bf7023"
    sha256 cellar: :any_skip_relocation, monterey:       "67ba7d9f9e555adad77a48e5458373d9664a725091fe81977d87fbf3abc2a1c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "34874794b85911dd6c4789000ef2c2a2cc681ecc2bf34ad32aeb3f4d30057e4f"
    sha256 cellar: :any_skip_relocation, catalina:       "ec7630072239d6d02ebdc5948af8ef601115be3f7d08814a1e03d774c67297fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50398171f683ddec8e704af636b3196516a3b6471d7f9ebc8353483dbfc50797"
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
