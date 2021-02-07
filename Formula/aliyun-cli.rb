class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.70.tar.gz"
  sha256 "14ae18db3a4e58f8c2f6fb591d9b1984109ab6541d02bb653843edee9ca2304a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "80acdf57680db7a8c04c10cf0d052115685cf34ecf5e4d53f12336db8379a704"
    sha256 cellar: :any_skip_relocation, big_sur:       "ee5c3e65afac02f97067bdb8d4dc62e0e8914fcd3a62db5e664334f3705af435"
    sha256 cellar: :any_skip_relocation, catalina:      "7fce8f65771b9d5f2eaf4d0a0bee81e6a39a3d0e863d46f9b095af4c40d9614a"
    sha256 cellar: :any_skip_relocation, mojave:        "60bdb7a637d2c509b60462a659c56c1d3c222076523c8ed6774ab3d5539cc5d8"
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
