class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.62.tar.gz"
  sha256 "d7121a39c9a14db5c4dcc759977d95e94150fdcf183681339bc8050ba6f2b26d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "cdde1deb5a59073af975accde2a43e3bda0c5929cad3cc114fcce71afc51b269" => :big_sur
    sha256 "fa399f0ea411bdcbcae28fa7f7ee108b0ca75dd51ddea3b41cd6f5d591e814cc" => :catalina
    sha256 "39ca59a1bc8ee8dd2512f6d2e535d085884dbd8b40355ed4f9eaef8244eef1dc" => :mojave
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
