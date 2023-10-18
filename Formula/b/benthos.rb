class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/refs/tags/v4.22.0.tar.gz"
  sha256 "569827f323c682ad87cdb00a31f104f36f9b3089d9b68823ad9e8071daed2b64"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a75cf95d5e0fcf988fcb1254d07f61710294e70bfe690f12ffc7f1e4ba279e70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b6e7cb139b82b18084a92674853909c0bb100ef8bfc47206b8d27f07cb29475"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9e4005f5d135d9df6a690526697c63cf7e44a551763cc7745a2f7000a8b4b5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "44b0da65fd695fb740c74daded76c9a416bccf919ff98c1de6a75ed37d5ca6e0"
    sha256 cellar: :any_skip_relocation, ventura:        "c6696f46020d0dd3d19507bed37deae9ceacf497730fdcf902d069f329e214c3"
    sha256 cellar: :any_skip_relocation, monterey:       "40f1aefa7070deb8a9fc0d44ca5f2b3ed0203cf2e65a003c6a581e3ef78325b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba60df68c9d79b1ad4adfdf9e5ee9b1997d10a3d4fdc251a7d29e83fba6035c0"
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
