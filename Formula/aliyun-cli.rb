class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.68.tar.gz"
  sha256 "3e3ec6a942be7b558a6a5b82eacade539061b0612ce63e9966b797e69bbc3f5e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a2b907dfdf6501acb7c4e687a99f00986b45e68df50ff36e94fd7eb1d72a02e" => :big_sur
    sha256 "a71e9efe791ca38f748250d63985a08b0b2f669c5c9d0435ae057d6865635622" => :arm64_big_sur
    sha256 "2459f19e21d19673e1eea47c13614052cc14f8cc6a6fc7d616ca3cd89ac97d8e" => :catalina
    sha256 "43243173df150a04c0b17f9d42276e979784d13c9d1102efec26455d7d01f4f5" => :mojave
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
