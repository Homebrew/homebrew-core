class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.35.0.tar.gz"
  sha256 "5b3f538b08f7717dda983567f73ba7c4feb85400417a3683b75634aa2a1ba36e"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f14a3ef9be0d48b5c90a6ee8ed44b363c6255206040a7021146553dd635e9ba5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e5a15d2d96eed311c9c2ad28de1128c65f035875c161427db11a172871ad7b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24a690cf833aac6320a491cb2657e7ae8d6c20bdf4c11bcf089e9a64ec53af4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d67416eb95cee26256aabcaf96cdd3bc2a544e18505d0fcd217291f9e219c5e"
    sha256 cellar: :any_skip_relocation, ventura:        "ae864e6a2249fad0a32ac5f4bb4466de0d081269f10e1538fd97c7d7490eb289"
    sha256 cellar: :any_skip_relocation, monterey:       "243f55f6f34651ff769b1b36a87663e008a6d979fee0aaecffec39d20065f10e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d46b33545c2abe2d5892cbf6aa311cb5e3ce9395fe77a60fa9a4ecec8e855a3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/benthos"
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
