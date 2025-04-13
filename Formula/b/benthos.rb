class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.47.0.tar.gz"
  sha256 "3cecbfd79c81a23adde667b36f274a3c145e05b5ea09e8a69ff3e73358d80858"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f81a46aad78765f247f036dd59caae5e450acb991658a9ba6bcd7500230497d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f81a46aad78765f247f036dd59caae5e450acb991658a9ba6bcd7500230497d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f81a46aad78765f247f036dd59caae5e450acb991658a9ba6bcd7500230497d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3061154895ef9c6be72c84055eabeb424c354ecbedb2baa8029e95388da8414"
    sha256 cellar: :any_skip_relocation, ventura:       "a3061154895ef9c6be72c84055eabeb424c354ecbedb2baa8029e95388da8414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc41aabc696092001c15476928cfdfc1299ab7afdc13169dbf10be28be21f581"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~YAML
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
    YAML
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
