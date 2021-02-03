class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.39.0.tar.gz"
  sha256 "282d24b989f69529c1ebc17efa81fa9b8f8df3158a25ea2c462aa5e64be1551c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b34e9ee43b15ec83a5a5ea37b71583c1f787dab76cfbe9c0e2a9e53b89c66712"
    sha256 cellar: :any_skip_relocation, big_sur:       "92bd42cb16d1c9caa8e8d323c98aa329437b8fd974c4b28b1bfde42c54098bf4"
    sha256 cellar: :any_skip_relocation, catalina:      "778a4e188c95ac9239f7a717b936426fd80051ea0527855822903c9ffc1536a6"
    sha256 cellar: :any_skip_relocation, mojave:        "2117066a1d41b5d199647a7e52e356608e1b553406c6f006eafd8d0772488916"
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
