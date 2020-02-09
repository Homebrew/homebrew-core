class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.10.0.tar.gz"
  sha256 "0e0552930a84800921986bf3e9e28f235665ea47b183f127c4402499384b75de"

  bottle do
    cellar :any_skip_relocation
    sha256 "27ec447fdd25ea998b272afbb010efa818b800f1e6c1341a21443e34083b25ab" => :catalina
    sha256 "a76cf7adf213795d7a5ccf9cd10d1e0d61f696da1668cd11e5d70c0838113a99" => :mojave
    sha256 "88121781c3a7b1a8c889f053a09be2096e6f55cea912df6b95e234034de745bf" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/Jeffail/benthos"
    src.install buildpath.children
    src.cd do
      system "make", "VERSION=#{version}"
      bin.install "target/bin/benthos"
      prefix.install_metafiles
    end
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
