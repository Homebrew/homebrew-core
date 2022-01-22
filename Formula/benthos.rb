class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.62.0.tar.gz"
  sha256 "356f9df491acfc974ad6acd5cef0d2224e0df3a296940c470c323831837992f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f09c4392b692d5922aff5d5fa46ffc885e01e5b0e05c3b11e067e23307617e75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79d45a372663205f773f53ac39480a6f5ea9c4957450a6a8971972db91dd0c0b"
    sha256 cellar: :any_skip_relocation, monterey:       "6b530ec4060d090df790c9a751023c9774bb0539cf2e2823de08189c0de567ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1182e27a21968a35b3179a02203fdf6a5eef679c6cec829df5c65784346aab2"
    sha256 cellar: :any_skip_relocation, catalina:       "ef4377c9bc1117fdb401178679dd28ed3b568aca3cfc3190ac2d1bd6b4a5256f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a979e3cce48ad250ac34ae79287f5abed20c747e03cb1d713206830e9f10fb6"
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
