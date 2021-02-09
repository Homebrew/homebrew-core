class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.72.tar.gz"
  sha256 "98b379a1438799cee49c53a155b288aba07967674cb996e011e3080a8f3a8b82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c29c18b8af327ae66f9058b2578adc0f4e8bc605c8198ce3d5e98d20b0d40190"
    sha256 cellar: :any_skip_relocation, big_sur:       "551843d93fa8aecb2ef40da2a853d08b76866cfcebde922e7dc5776e18d43fe2"
    sha256 cellar: :any_skip_relocation, catalina:      "9a98c72e440813b4a41b58b153124bafa196bb7536bcb292880dbbb55916326b"
    sha256 cellar: :any_skip_relocation, mojave:        "fe1ec77aa063e5545d12721ed54ae260e59853e16b1a3f9e6c59868827fb1012"
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
