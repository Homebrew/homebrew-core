class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.5.1.tar.gz"
  sha256 "76ca4a920089367f725218c73c024de07a3700584569bbad3c8b870c12d231f1"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f90438f7d064b5f8defb2920df9108d54a6201b598e9dc753151a77878121e7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c69308b6016249a3e29e819f730b94f8dda0b077966143a46bbb4e1d407f8e16"
    sha256 cellar: :any_skip_relocation, monterey:       "84dba2b096ae21adb0458dac2064f367580e6ad6d45d525a5971bb29f279b3ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "637a2d098b298ec70068e968371066ae7f1ba15b5cfff072e9785b95089e124c"
    sha256 cellar: :any_skip_relocation, catalina:       "e55a498a3db868b1e77b65a61edba00d766e0a36d88840b5b5c495838f86f072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7726973dd04de8f91a2ca9efbb3154c5a23819830840f635d9c69eaab25c4b4d"
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
