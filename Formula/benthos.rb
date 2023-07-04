class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.18.0.tar.gz"
  sha256 "241207f2749448ac42ac9f01b5c81328ab4d37d5b81b9e7c17f726849540560e"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "835d2c35d5e969832e3302b861ec0318eab5eee28399f6d6778eb9df5e2c199c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "919046e0d1e643819c7d7f0cf472867bd430c8fc32141c3d53377959d91b7b23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f1019efebdcfe51ca8a7dd868fe0bc46555085aec3d9a28f2ad8c30d4a51e97"
    sha256 cellar: :any_skip_relocation, ventura:        "8b7eacaee31861a5af5b6fa1d0972972f1e30fed021f15e701f6340e98d93a61"
    sha256 cellar: :any_skip_relocation, monterey:       "9d3f4a6df5962d7af01b9d487c655531093a8074e4d86afd51a2e9b5f91e42ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ee61f4c74b8f9c72552b132ca9f79863a89c83918cdc0669e71fb867cc31bbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "026e024bf6d11e727765dee9edcb9e9831f7ad8eb0be1d0eda10f59adaa0c9a9"
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
