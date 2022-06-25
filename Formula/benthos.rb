class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.3.0.tar.gz"
  sha256 "7db224e93d7c7ad3b9b70e478a341ca177f90f63f9805ead98d41a9b9dfed545"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c6f538b02378223da2b792aaef6ec8da904bbc4e38bea6c74abce9eb77d8dfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62c763601788481910ca4a381cc9ee0ec1075c57e49e7c5a40733d32370cb306"
    sha256 cellar: :any_skip_relocation, monterey:       "3f1e207783702d93a77acd7ca2c76be2cb48fc6f0d3c8254f58e4e40aec59306"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fcd955f5c5e1001927a1df5df2ad3c0c9e51d521319232ae2e0f4c8c9528711"
    sha256 cellar: :any_skip_relocation, catalina:       "e31382b5edd13821d6e39016e14e4f81e0912213246038b2a347f0eca1976577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0a34316d370976d7555cd246a54a9eb0dba80fa87878c63865e4a3fc4388a1b"
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
