class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.45.1.tar.gz"
  sha256 "f45a1b43932287ca3104df1df7e5330506fbf041c465f2933d7316ea80d45be9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b365375f473a68171a2f126693df8053d7083f0a5e13df4574880e427cb4fb2e"
    sha256 cellar: :any_skip_relocation, big_sur:       "691c0ef7bad57674f3335cd0b4547183aa2c84ac64de2b25eda558e7035ba237"
    sha256 cellar: :any_skip_relocation, catalina:      "a7c8b3acffb783c437bfe17f5c7e459d40c236bd27efa346f0f485c77f80f724"
    sha256 cellar: :any_skip_relocation, mojave:        "26e9de8c920678eb402e04eec7418968fa0f96b4e55a72ef2e429c0e92203c6e"
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
