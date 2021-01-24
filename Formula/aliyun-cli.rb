class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.67.tar.gz"
  sha256 "8658adab69a257a9ba33e7f9a9233ed267bedfa178009e284c548e2e92dcf611"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6bd29a874dfdfb4b3c2ed03f0514252506ac4c6272935b5472a7aa0539891f4a" => :big_sur
    sha256 "6c0f202c5fb98b5014b63eae71a3f24f6ef7c8e0d956ae18e67bcdff07d5e8a5" => :arm64_big_sur
    sha256 "bd6350e6edb655dfc91e282645bf738d1ad828bf76fb710bdf895ee745ddf969" => :catalina
    sha256 "f82e9b0ccea3770b1ea206f213ecb8a6975cde9052b8ac7087fdc8cecb978652" => :mojave
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
