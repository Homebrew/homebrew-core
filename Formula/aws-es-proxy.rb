class AwsEsProxy < Formula
  desc "Small proxy between HTTP client and AWS Elasticsearch"
  homepage "https://github.com/abutaha/aws-es-proxy"
  url "https://github.com/abutaha/aws-es-proxy/archive/1.1.tar.gz"
  sha256 "290ec4ef5186b94e1f416550fe8a842fce04ed10937fd0d5580470e1552d5be8"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc7b61f5e22fb14108c697fd16d8e10f1dc7c25ba4e198aea9048d5a1ab49380" => :catalina
    sha256 "04072658dc075c931b5090ed0fc8a7d918388f3352c2752e03eb22f8cda48cb6" => :mojave
    sha256 "12e316705d1c4730b83f9a7a31559b7968f4c3bace93569902db6a57da0b6966" => :high_sierra
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
