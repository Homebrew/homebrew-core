class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.30.0.tar.gz"
  sha256 "315ea0de39a39e32a23875b5cfe3e5690462d0ea510ff69a3d7a7d2663de4e01"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "909fb2e650f1db7f9d7a6c079927417b131ecb7a651d20b4e54947cc8a26ef15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14a9c84b0cc212c0a64d2c11dfdf98fe0e6dc7cbbc8a583b83e69d381de56f53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "990a5bb9d5b9eaf08f1755e91ed0bad934c7ce20891392a2301c722816550c00"
    sha256 cellar: :any_skip_relocation, sonoma:         "325b5aa345c3bb7d201386e1a4387a1d9c273257bc5dcc07d85f28df6518cf79"
    sha256 cellar: :any_skip_relocation, ventura:        "7417a2febb2f1232212fa4c6b4c633ca44e58f6c6f046c006e0efeb10de07c7f"
    sha256 cellar: :any_skip_relocation, monterey:       "64a9ee1d8e36136264d3ca24a8319624323830eb1990ea6bb84a2b7d531bb641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7791136f2f32ae8e29c9b6a95093a0bc869b10be4d9849453fb96553383c2ad0"
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
