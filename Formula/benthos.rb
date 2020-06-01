class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.16.0.tar.gz"
  sha256 "54906dd1300ca1dc359ef80376c1375395b1a6a0eba0c3f0f601d08f25eebafd"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea3156a03d31bcc9d38003a5c24baf2f33dc98e0d5efd3563ed42dfb0250e966" => :catalina
    sha256 "5003d09ebc5fb0214c5655ac86699d257c50cdeafc9db19877ac63d398f18701" => :mojave
    sha256 "1bb4937207233e2f49cd2f7c3b874b7b167893ef38fdf8e8f2905c5b3c90f556" => :high_sierra
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
