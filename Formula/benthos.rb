class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.1.0.tar.gz"
  sha256 "9e90b9ee4cf48e5a8a6dcbc87cf8afe64e3f1a358b3febafb24db3e2059aaf21"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38de318ddfa2d660bd21962752a903c3073d956424e3e4a98dfd7cf9f7aff2b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9c4457b8ca071ba940ae3977375c5766e42cd3439e99028377f63d95841a120"
    sha256 cellar: :any_skip_relocation, monterey:       "bfa109d0419aed1788a01a3f379ea9cd0b76401b4f670f6ac20c303f6976b756"
    sha256 cellar: :any_skip_relocation, big_sur:        "65248c8dfad760fcbcc8b47e3c2a5e157bd720085d3980a522cfd30d97822fc1"
    sha256 cellar: :any_skip_relocation, catalina:       "0a19802dc9bffcd692cdd7852bdc1feaf6cadc3d93a9d4e9014a01257558aa4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ffca84f53e5fc56d3c56aea679ad684042088bcd7ffe5c402dde257e42ab9f8"
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
