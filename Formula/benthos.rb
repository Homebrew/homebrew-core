class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.57.0.tar.gz"
  sha256 "719be1a20755970762034dfa8ddbefd38598204992fa9782ddc9de5862405249"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "20d504b29dc24e4ba58fafb35b4275e1473d5532e5868a1fc04ac190537ffb0e"
    sha256 cellar: :any_skip_relocation, big_sur:       "39609d36e463ff8baf03b8bb83531131164164ab8c0713a1380ef0636fe767c7"
    sha256 cellar: :any_skip_relocation, catalina:      "1de93c9a6325a857b8db4dba2891b9039dcf9e65836e8aec9bc6468f85a97b34"
    sha256 cellar: :any_skip_relocation, mojave:        "9ef7703b5db277ffe76f254f8a7159b36dfcd3f16a73bac92ee7b7d5653c5f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc6aa20fedd52e7ff4032e5c1f5ddee0b5b735e0212cdc23018373242c37ff1d"
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
