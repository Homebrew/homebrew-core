class AwsEsProxy < Formula
  desc "Small proxy between HTTP client and AWS Elasticsearch"
  homepage "https://github.com/abutaha/aws-es-proxy"
  url "https://github.com/abutaha/aws-es-proxy/archive/v1.0.tar.gz"
  sha256 "9e4177610369f149cc64db59564e1621e06d7203d0acdaa56cdbd14c47079171"

  bottle do
    cellar :any_skip_relocation
    sha256 "45a608977ee8179e9a3356a6aec67ac28fb45a2eaa220f12ed14ab3502786671" => :catalina
    sha256 "75ef7d6a9a21e85cc0686eb218eb22c571222432751ecc10fbb53761e17c4977" => :mojave
    sha256 "57b9c927fbf351bf8b2b7b87bd21496ce473cd6058615cf8639621fd8d39a32d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    prefix.install_metafiles
  end

  def caveats
    <<~EOS
      Before you can use these tools you must export some variables to your $SHELL.
        export AWS_ACCESS_KEY="<Your AWS Access ID>"
        export AWS_SECRET_KEY="<Your AWS Secret Key>"
        export AWS_CREDENTIAL_FILE="<Path to the credentials file>"
    EOS
  end

  test do
    address = "127.0.0.1:#{free_port}"
    endpoint = "https://dummy-host.eu-west-1.es.amazonaws.com"

    fork { exec "#{bin}/aws-es-proxy", "-listen=#{address}", "-endpoint=#{endpoint}" }
    sleep 2

    output = shell_output("curl --silent #{address}")
    assert_match endpoint, output
    assert_match "no such host", output
  end
end
