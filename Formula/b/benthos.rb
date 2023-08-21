class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.19.0.tar.gz"
  sha256 "fa3bb0facf4a8b68f3d91d4395b7927cff8863379a8c42e189d9c19dbfd5caf5"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd6da1b1c9e550c4cc79f5dbd2298b9f02dbc582cfd18276c37c02c8fcce16bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db898c977f81dd2578eec3d48a047da236a47734e3a95871a40edfc193af83b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "413147f14e149906988731bf392d7b8d1be31facd3ac09f1e050d168ca34b63d"
    sha256 cellar: :any_skip_relocation, ventura:        "9fb9a74af7f500945d980412e8ff2f1e1ee6eb5a8eb9e2eb6e881be2ae0a9cf6"
    sha256 cellar: :any_skip_relocation, monterey:       "6ec05d7dd85df9c42a2f2baabe736f44da796412c8324b83ef6e2a228ef6124d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b490d68b46ae01319592768f51d3a75d04d6a34ccbd3f47d2391d81b7a74c4cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b266893c4a5a8a05e55b22c97821c8c90107926eeeb0fc4d74d825fd5026e5f4"
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
