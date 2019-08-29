class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v2.14.0.tar.gz"
  sha256 "6545c8a49dfcc03156feb385a5e61881c4747d48a3da3711242d0ac819cb3d99"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f44ce90e385d63ccdec1e4b1961c873a60723208ea900b8cd073bcab14f2b0b" => :mojave
    sha256 "1ad68acfcc2bb7a136e6572aeb5f64887cfd3b3f3b2de4e13d75e3247fc542b0" => :high_sierra
    sha256 "759d7a91908dee5a907f8db37561c2f0abeb4ca1db98c5ae081dfa54775705b2" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

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
