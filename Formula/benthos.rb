class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.10.0.tar.gz"
  sha256 "0e0552930a84800921986bf3e9e28f235665ea47b183f127c4402499384b75de"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a3fad7da2f7bd2901e93177e241f6085786e7a8cf2efcaaebb4893af6f4a6d1" => :catalina
    sha256 "dc90d7771f82882d8e348092c865a560e18fad74ea64ecf717e11fdc0387ffe9" => :mojave
    sha256 "d24147b3311ced06ae0bc81923269399baa334d9e5447f36c86584e477200ca2" => :high_sierra
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
