class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.73.tar.gz"
  sha256 "ebc33ef6d3ec049f9b7068585b5843684c0704f8d6b11d50550cd14a28699534"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b9c3680f87925e655aa68370be78b4ddd462c9ae58d59b9d924b7849f839189d"
    sha256 cellar: :any_skip_relocation, big_sur:       "7daf71051e0e76a1ce39eb2e4bc97f48c4afa0390f4b440bd656048aa64e5b98"
    sha256 cellar: :any_skip_relocation, catalina:      "56a2b2fd66140a7db1cd05e5c392b7a4e865c1e964294a5ca571b726bd9a9a01"
    sha256 cellar: :any_skip_relocation, mojave:        "b9fffe73ffa64b5e9d8583f4b6a0323a9d95feb52520b62fac364322a533e7a3"
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
