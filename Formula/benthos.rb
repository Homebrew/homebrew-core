class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.2.0.tar.gz"
  sha256 "946bbfe469d88901c8314a42b2b7ea7b243f2faebbcdd55fb94ee151e57d00f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "e92f3be37caa211625ae33cd9f857093fd202579d0ae403d6ead9d2d4f6e74c7" => :catalina
    sha256 "982735cc0abb60673f681b2a6b29971ee61df3469c5136246c375b50524c1ddb" => :mojave
    sha256 "8f17d739cdaeece8b44532d97244d22a34eb0728f0bbb6a7cef7db8d9874f4df" => :high_sierra
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
