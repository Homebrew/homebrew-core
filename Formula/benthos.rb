class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.9.1.tar.gz"
  sha256 "e5cbbfb3676d1b4d2dd4e93b64e6f2a1d18917f852ec8cce26f2a37a9ad82527"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e31f29b3c20d5448b35c72fdb5867f9343812c97f806ce40b1fc30ec8ac2e781"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcec817f7fb74e5014cbaab046f95111c27a97e0e09bf72586e4b10250ad21dd"
    sha256 cellar: :any_skip_relocation, monterey:       "3368b157f14aa73e06e17faf0a5e09e5d620425cfb8c6939eb160be24ac262e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "499e039d14c02182c70a7ada3e5513ae9b935da0ca9e7d94b86f4708823a30c7"
    sha256 cellar: :any_skip_relocation, catalina:       "79a150af71f90d1927df2672ab4890cb1b6138188144e2844c65b35092b341e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae73525c5bf3f611c4e18fce717806db81c3fb32b3296cce709e17de687d7c47"
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
