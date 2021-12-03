class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.60.1.tar.gz"
  sha256 "f2e9b37c5bed391b40da5b1c3c9c555250490f95f76fa8b52ec351992db84c43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3825abd0926f18b3f7f491611334ab1ed9f8b046427fdfe63c2490d3f6fd32a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45408ffb7e1b0591ebf104f09000d32861d0659ff73b30624e4caa97727d33b7"
    sha256 cellar: :any_skip_relocation, monterey:       "0c4dec160e4ce91549b78298352080495c6f93a23cf87189646343d723ba4420"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5e7757bfe2673442015099917fa5b66575559aaa0230f3fb8b43635518365a7"
    sha256 cellar: :any_skip_relocation, catalina:       "4c4cd52608b1ee75366863eb519d65affcc67c3a6e0681184b7031cd58111f7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3afd66a6abed4da2496609073c02f0e9b4bbd994f0efa6ac15fcac43cbc97f72"
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
