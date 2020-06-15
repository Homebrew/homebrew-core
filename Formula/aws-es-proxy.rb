class AwsEsProxy < Formula
  desc "Small proxy between HTTP client and AWS Elasticsearch"
  homepage "https://github.com/abutaha/aws-es-proxy"
  url "https://github.com/abutaha/aws-es-proxy/archive/1.1.tar.gz"
  sha256 "290ec4ef5186b94e1f416550fe8a842fce04ed10937fd0d5580470e1552d5be8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dcde740b60a4c8d4e79ac43000992151727939f312cbbedb536ec36ed1cb43cb" => :catalina
    sha256 "7a4e3468b4ac116b63824fe7d96b53bc82bd2c8020bb525cf1ecf2a5cf23418e" => :mojave
    sha256 "87f6a4e1f5b0a7fdf110ef2502bbcdbf1228db7ba9eb12be26b144812202ea03" => :high_sierra
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
