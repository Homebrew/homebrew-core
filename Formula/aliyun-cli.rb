class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.68.tar.gz"
  sha256 "3e3ec6a942be7b558a6a5b82eacade539061b0612ce63e9966b797e69bbc3f5e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f68eec3a881eabbcf12b6c93ab944ed17cea43f5236b36a71f1f4ddcb0ccbbb0" => :big_sur
    sha256 "fb5c03f5b0aa67dfb9ea43ed8ad7c6ec46d17ddd0baeac27869822d8d5b06e54" => :arm64_big_sur
    sha256 "bdbb50e31eeba2053ec9f588022653fb7d255df9c44e2e2dcb6d751d49239e9f" => :catalina
    sha256 "18e3dcd97d1ac6b1a48c3adda920b1af944013944a85c0271103ac0f2ca4e67c" => :mojave
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
