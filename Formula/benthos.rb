class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.63.0.tar.gz"
  sha256 "8e0bd572dfb2508dee4fd3398eecd16908910aec0607a148d7f94ef2ac3f4f0d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5945dfdeb7401713fe222b5a65f3821afd19fd7ccdcc3b89b9e6b62949868616"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdb69af338756e85e2f131b2744e0998abb10d02b500b1d347cb42a800c1d691"
    sha256 cellar: :any_skip_relocation, monterey:       "432f070ab00c9fa771c460bacd8895a06bd77f33ba55fdd40a69a004d0d46c18"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cfe69a46af567dcf779beb94dd6fcc963ef7564bd7090922ccd12f3ed91f351"
    sha256 cellar: :any_skip_relocation, catalina:       "f04b56048ac4a905abfa55b178d44778fb9bb8c45a9c6b97453fadf245f0ab12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63d42d38a54b8594784a088040822c96169e7bbd2869b8d1acbbdd04e3129c8e"
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
