class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.10.0.tar.gz"
  sha256 "3c184056ff2902fbf2e7220ea15c3f447aa9690c8e4942a835cafa5333b0e657"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef20ba74f5b22009816b18e6f1044c96cea23efdf882f394749ca78083aa7841"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d235a6b3afc24b76b4339c1344fff3b7e4d2ca1c7c563678c0f3b43509627609"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b0cd5c745549621a6cfff2cfb1ceda85ff08ea0898eb88fb635328ee7a2facc"
    sha256 cellar: :any_skip_relocation, ventura:        "119bfc6e9d7e28cdd4d63fb208bfde0e34ae5a8e16f4c09485a36889c8138d15"
    sha256 cellar: :any_skip_relocation, monterey:       "83a57fe7ba402a075ad99208c00bc22aa70817a3b8a0f310ab5aff3049041f87"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c9495e4f6e2e2f40a907c0ea8c5011912672cd8dd66aa87a7d9836f0106ee8a"
    sha256 cellar: :any_skip_relocation, catalina:       "9d7980808fac3923d6cd3dc77f7fd0ae5966481f390f579c08da4422b5e62cbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99aa2271ae39842aa0348cfc0ae4490953fec9373695d3a5c96f33664e31d294"
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
