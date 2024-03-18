class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/refs/tags/v4.26.0.tar.gz"
  sha256 "39b62db2429e6c74d1876bf0fdf56fe70a5fdba040d7aae48db9e01f495e25bf"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4668b2aaa9d2da3b92567ee5b6dde33ac6e5618c8e24e234666b8ee9d159f272"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "747fd97d206aaa6c45751520a8bc2212060d63d5f29416c0d74b63e85e3dfe84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb9aa3a2be442762cdbd12a8c31561238a11302070dcdabaf117e697b02ff0d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "60bf4a00b4d3125819bc8ead2b823f2d1b91e53c029151334a2100129b3eae20"
    sha256 cellar: :any_skip_relocation, ventura:        "cbb70233bf2f9425065d0db8d76355a067912e93be84335aad99e9d055166fb4"
    sha256 cellar: :any_skip_relocation, monterey:       "09c1797a81e6178277c1cc77d91bea218436b2a9b84c3afa51cdccf25cdab00c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f508ba87277721785b54fd0a6b19d139acb21d54aafcfc5bd261c4e0f19c9093"
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
