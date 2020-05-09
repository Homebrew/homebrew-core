class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.42.tar.gz"
  sha256 "83957942c9c0ebf0e529f0b0e0bd9662db7a4eff85f9842d5610c794007b081e"

  bottle do
    cellar :any_skip_relocation
    sha256 "2599405b262b6c5d798a17631c7b02d1aba34697cab7a6cb901f8e42a54974b8" => :catalina
    sha256 "7bd68f1f3b135421146ac9a358a481ec21b295fd93e98d1f24ac4fcbf64b6330" => :mojave
    sha256 "719a03c4e41c592898be7ad483db1b6b05198df9f098d554ceb7783d6065bbeb" => :high_sierra
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
      prefix.install_metafiles
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
