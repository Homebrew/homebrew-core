class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.17.0.tar.gz"
  sha256 "77945362bc39e9144b8e5eb6a0a44523b29610988b73aed497a0d815199a5dd4"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "073ea6f81ecab3a2148afaf4e825bd4a0654ac22a7d3f50be7883129cb9b366a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eae5170b0ce6426f348ceab337163a1ff300c0679d2e056c797660fa9ae118b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2b0b7aab1105086de82760927c233b1e978c8235e266539ec8fcd7c64ce1e3b"
    sha256 cellar: :any_skip_relocation, ventura:        "6334601dff65749b3659e4820c5b369ef74304bb53a2792eef8385ded5b7482a"
    sha256 cellar: :any_skip_relocation, monterey:       "b65e85d199a6b511965b15c04e84258d25916b107bccd0b9bf81bf0825e9ac0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3902d5b0351af20f316d9f7dfb576f5b5e819f7ebfef8c28ebaae31f72778f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe1e77ac416cd26ab38d0c2e02b79f05d8999d9ec67b404a586e34624e3e6fa0"
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
