class AwsEsProxy < Formula
  desc "Small proxy between HTTP client and AWS Elasticsearch"
  homepage "https://github.com/abutaha/aws-es-proxy"
  url "https://github.com/abutaha/aws-es-proxy/archive/v1.5.tar.gz"
  sha256 "ac6dca6cc271f57831ccf4a413e210d175641932e13dcd12c8d6036e8030e3a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2b1415650725652e3282217d2c09464410645b225f954101259df3827b4a135"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2b1415650725652e3282217d2c09464410645b225f954101259df3827b4a135"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2b1415650725652e3282217d2c09464410645b225f954101259df3827b4a135"
    sha256 cellar: :any_skip_relocation, ventura:        "ca006b5fff25e619563f739d83881a461d0c763c9501d144b355da1940075468"
    sha256 cellar: :any_skip_relocation, monterey:       "ca006b5fff25e619563f739d83881a461d0c763c9501d144b355da1940075468"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca006b5fff25e619563f739d83881a461d0c763c9501d144b355da1940075468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11d0bf2df2385efb683589d960858d194c89ba11db563faebc76d6405f07c078"
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
