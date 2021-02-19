class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.73.tar.gz"
  sha256 "ebc33ef6d3ec049f9b7068585b5843684c0704f8d6b11d50550cd14a28699534"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cb8a069eb5c1a1f72691998dfd07c0cfb3803e8c5332bcbfcdce32d12a5ece43"
    sha256 cellar: :any_skip_relocation, big_sur:       "a2b981b487f700cf0428d67e1131c23764137e77252ded1099467a58c52a3628"
    sha256 cellar: :any_skip_relocation, catalina:      "a719f997691835d664bde48a66820fc4a0dd1802ed504c49bcad9ca970006f83"
    sha256 cellar: :any_skip_relocation, mojave:        "010ba98969299f288242e67018fc0362e1b74be2cc9490e2478312211f97ab84"
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "off"
    ENV["GOPATH"] = buildpath
    ENV["PATH"] = "#{ENV["PATH"]}:#{buildpath}/bin"
    (buildpath/"src/github.com/aliyun/aliyun-cli").install buildpath.children
    cd "src/github.com/aliyun/aliyun-cli" do
      system "make", "metas"
      system "go", "build", "-o", bin/"aliyun", "-ldflags",
                            "-X 'github.com/aliyun/aliyun-cli/cli.Version=#{version}'", "main/main.go"
    end
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
