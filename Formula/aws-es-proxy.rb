class AwsEsProxy < Formula
  desc "Small proxy between HTTP client and AWS Elasticsearch"
  homepage "https://github.com/abutaha/aws-es-proxy"
  url "https://github.com/abutaha/aws-es-proxy/archive/v1.0.tar.gz"
  sha256 "9e4177610369f149cc64db59564e1621e06d7203d0acdaa56cdbd14c47079171"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a2b9b87d015af49e5061556d2ab93d901831aef4c2331624f573a451a9620d2" => :catalina
    sha256 "35421935cd1cdb758564d9fb6328aea304d2d1850539e5e407e2496f3963842c" => :mojave
    sha256 "f8f4c0fc627d3a2319b4ddd51c692040f97fae904a3c4840890740a0a3a0d3ff" => :high_sierra
    sha256 "a7909d452eae3f5f34f982f98af35be8c814d9b9476c3c7a2f479fa6f5e9f631" => :sierra
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
    begin
      io = IO.popen("#{bin}/aws-es-proxy -endpoint https://dummy-host.eu-west-1.es.amazonaws.com",
                    :err => [:child, :out])
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end

    assert_match "Listening on", io.read
  end
end
