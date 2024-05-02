class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/refs/tags/v4.27.0.tar.gz"
  sha256 "f196b90d1df54641110f9ac04e7b82c079190495e1a26785056cc9bd8abd2e09"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9453f921c00364cfb6bc8efcf7dbeb6da3f4630bf49d6866fa830e472fa2295d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52588dbfc82e79cb00c5b900867d43ecfe41fb10efa45e6f0b3d8996e14ec4eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0fdb60bd71fac017ad818e079e26553285155dcb2bb91bdfd48e671339a4a1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "aaaf2201cdffa8c167b9b3ccc3241966793d49531925b6a3379b81070d64a219"
    sha256 cellar: :any_skip_relocation, ventura:        "cf361832265f9a03d4a5b0ecfc70a62634ba58a7f2ebe5b74cc1ddc113769503"
    sha256 cellar: :any_skip_relocation, monterey:       "c282fb0124e7a71c07e9b1160b35ae52e1bcd865231c217dfed6a0089273edce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07e3b6a34ef577958337fd14fd09213207fe1cb663fef5bd6bf949e45f5fe840"
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
