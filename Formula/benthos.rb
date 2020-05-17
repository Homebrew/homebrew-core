class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.14.0.tar.gz"
  sha256 "3ef1e707279cb1b9d93e3b8060fa373aecda0f7ec117cb0024333aebcba7ad18"

  bottle do
    cellar :any_skip_relocation
    sha256 "599485f682abaef24955c09190956d58375362f213582961d62f6c60a009eddb" => :catalina
    sha256 "f62220172d926f6d9b1f11bddf3107f60c2172381ac11386be12fc611b6fc277" => :mojave
    sha256 "b8c775c3b7e3699f8aa9aac75b30c96cea0a7c8db9417f80cd87a507ffbe0836" => :high_sierra
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
