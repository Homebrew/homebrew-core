class AwsEsProxy < Formula
  desc "Small proxy between HTTP client and AWS Elasticsearch"
  homepage "https://github.com/abutaha/aws-es-proxy"
  url "https://github.com/abutaha/aws-es-proxy/archive/v1.3.tar.gz"
  sha256 "bf20710608b7615da937fb3507c67972cd0d9b6cb45df5ddbc66bc5606becebf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b053918e93c51c2b3a562dc30cfbcf30f07f2c10b841b5c61ab146595920368d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ae9e19bb22445be989da3b8407bc42fba17a3f512d692bd8d727751b1703757"
    sha256 cellar: :any_skip_relocation, monterey:       "d6b34390ba856f75db3adf881e2659bf48c6d420abe8d4de1226e59c607e0a41"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d172bf29028041152acbd6635aee845193fc19f0b8d4e086ed4a28ee9354a37"
    sha256 cellar: :any_skip_relocation, catalina:       "1e1cb5b16185e9948621055c4960b608973110c5d68ab10cc07c61f52d456010"
    sha256 cellar: :any_skip_relocation, mojave:         "a30caee0acb5d3c89764be328025d84c9cbeb2adce32a97b78048c399576bff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "927e9fcca53a19b16b22d363737b24111ecfd333dc9f969086b0e312c3d30a74"
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
    assert_match "Failed to sign", output
  end
end
