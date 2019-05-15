class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.15.tar.gz"
  sha256 "f0e561d900cb3aa70d6e5a909b14a84838cfc260e52bccbb15dc5f87170187d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e658c200e777c2a3fc65e188b793888b72a989ca04a9955eacbe16e73a54d76b" => :mojave
    sha256 "52bef7b4f9149f6c4bf0ce21c7646db7c278127b683ba01ce115b2dbbba2b4bd" => :high_sierra
    sha256 "4e1fbd235c12c421a997bbecf3f5be40e4cf3cf94a5b05fe35c004736364e5ec" => :sierra
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["PATH"] = "#{ENV["PATH"]}:#{buildpath}/bin"
    (buildpath/"src/github.com/aliyun/aliyun-cli").install buildpath.children
    cd "src/github.com/aliyun/aliyun-cli" do
      system "make", "metas"
      system "go", "build", "-o", bin/"aliyun", "-ldflags", "-X 'github.com/aliyun/aliyun-cli/cli.Version=#{version}'", "main/main.go"
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
