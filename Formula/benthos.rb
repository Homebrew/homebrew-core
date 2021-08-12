class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.52.0.tar.gz"
  sha256 "59957c0e479f11ece25c8fc6a88e484ef7e2fd226e16c6a4663058eed7a29982"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c5190927fc4c6de7353d1d7521c2f40bb67ba34f56bb609088dd3b83669c85af"
    sha256 cellar: :any_skip_relocation, big_sur:       "0615cf7a6a61d75331dedcbc59321408d9d7a861f744d5b9bf70b76f38511571"
    sha256 cellar: :any_skip_relocation, catalina:      "7eaa697c2edf1921defcbd6a629bfc5bbf21626134225361c7a6f1861a9817c6"
    sha256 cellar: :any_skip_relocation, mojave:        "deaac1c160b4da0a430d60d5bed4fe61396e394091800eda30cdce7b551c3818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c8b82d54a4f3f302472310748c1d1311576d1cbf2e3146a70a98ca0d1a43a68"
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
