class AwsEsProxy < Formula
  desc "Small proxy between HTTP client and AWS Elasticsearch"
  homepage "https://github.com/abutaha/aws-es-proxy"
  url "https://github.com/abutaha/aws-es-proxy/archive/v1.5.tar.gz"
  sha256 "ac6dca6cc271f57831ccf4a413e210d175641932e13dcd12c8d6036e8030e3a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6027f93eaf468cef549261cb4ab8d9605fbc7eb039f00d387a066c958e549692"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b053918e93c51c2b3a562dc30cfbcf30f07f2c10b841b5c61ab146595920368d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ae9e19bb22445be989da3b8407bc42fba17a3f512d692bd8d727751b1703757"
    sha256 cellar: :any_skip_relocation, ventura:        "ba6e4eb41e1319edc2fb59dce4c0e9ac41a3ee461fac5240fc1bd3e98b66ed21"
    sha256 cellar: :any_skip_relocation, monterey:       "d6b34390ba856f75db3adf881e2659bf48c6d420abe8d4de1226e59c607e0a41"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d172bf29028041152acbd6635aee845193fc19f0b8d4e086ed4a28ee9354a37"
    sha256 cellar: :any_skip_relocation, catalina:       "1e1cb5b16185e9948621055c4960b608973110c5d68ab10cc07c61f52d456010"
    sha256 cellar: :any_skip_relocation, mojave:         "a30caee0acb5d3c89764be328025d84c9cbeb2adce32a97b78048c399576bff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "927e9fcca53a19b16b22d363737b24111ecfd333dc9f969086b0e312c3d30a74"
  end

  depends_on "go" => :build

  # patch to add the missing go.sum file, remove in next release
  patch do
    url "https://github.com/abutaha/aws-es-proxy/commit/5a40bd821e26ce7b6827327f25b22854a07b8880.patch?full_index=1"
    sha256 "b604cf8d51d3d325bd9810feb54f7bb1a1a7a226cada71a08dd93c5a76ffc15f"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
